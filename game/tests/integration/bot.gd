extends SceneTree
## Cliente de teste sem interface (ADR-0008). Fala com o servidor só pelo protocolo da Session,
## como faria um cliente adulterado. Papéis:
##   a: pede de longe (recusado), anda até o cesto e coleta; espera b sair (servidor continua vivo).
##   b: tenta coletar o que já foi coletado, um objeto inexistente, envia entrada adulterada e mensagens inválidas.
##   w0 e w1: colhem metade dos feixes de trigo cada um até a missão concluir as duas missões (colher e entregar); late entra depois e vê tudo concluído.
## Uso: godot --headless --path game -s res://tests/integration/bot.gd -- --role=a --port=17777

const TIMEOUT_SEC := 90.0
const ACCEPTED := "aceito"

var _session: Session
var _players: Dictionary = {} # peer -> Vector3, último estado recebido
var _tick := 0
var _confirmations := 0
var _confirmed_by := 0
var _denied := ""
var _deliveries := 0
var _side := 0.0 # deslocamento lateral de cada colhedor
var _mission_progress: Dictionary = {}
var _mission_done: Dictionary = {} # id da missão -> concluída
var _done := false


func _initialize() -> void:
	Engine.max_fps = 60
	var args := OS.get_cmdline_user_args()
	var role := CmdArgs.value(args, "role", "")
	var port := CmdArgs.value(args, "port", str(Session.PORT)).to_int()
	var game := Node.new()
	game.name = "Game"
	_session = Session.new()
	_session.name = "Session"
	game.add_child(_session)
	root.add_child(game)
	_session.state_received.connect(_on_state)
	_session.collect_confirmed.connect(_on_confirmed)
	_session.collect_denied.connect(_on_denied)
	_session.mission_updated.connect(_on_mission)
	_session.delivery_confirmed.connect(func(_id: String, _by: int) -> void: _deliveries += 1)
	var peer := ENetMultiplayerPeer.new()
	if peer.create_client("127.0.0.1", port) != OK:
		_fail("não foi possível iniciar o cliente")
		return
	get_multiplayer().multiplayer_peer = peer
	create_timer(TIMEOUT_SEC).timeout.connect(_fail.bind("tempo esgotado"))
	match role:
		"a":
			await _role_a()
		"w0":
			await _role_worker(0)
		"w1":
			await _role_worker(1)
		"late":
			await _role_late()
		"b":
			await _role_b()
		_:
			_fail("papel desconhecido: '%s'" % role)


func _role_a() -> void:
	await _wait_until(func() -> bool: return _players.size() >= 2) # b entrou
	var me := get_multiplayer().get_unique_id()
	var basket := _basket_position()

	# 1. do ponto de entrada, o cesto está longe: o servidor recusa
	var reply := await _request_collect("Basket")
	if not _expect(reply == Interaction.TOO_FAR, "de longe deveria recusar '%s', veio '%s'" % [Interaction.TOO_FAR, reply]):
		return

	# 2. anda até o cesto; quem calcula a posição é o servidor
	while not _done and (_players[me] as Vector3).distance_to(basket) > Interaction.REACH - 0.8:
		var to: Vector3 = basket - (_players[me] as Vector3)
		_session.send_input.rpc_id(1, Vector2(to.x, to.z).normalized(), 0.0)
		await physics_frame
	_session.send_input.rpc_id(1, Vector2.ZERO, 0.0)
	await create_timer(0.4).timeout # respeita o intervalo mínimo entre pedidos

	# 3. perto, o servidor aceita
	reply = await _request_collect("Basket")
	if not _expect(reply == ACCEPTED and _confirmed_by == me, "de perto deveria aceitar, veio '%s'" % reply):
		return

	# 4. b sai; o servidor continua mandando estados
	var other := _other_peer(me)
	await _wait_until(func() -> bool: return not _players.has(other))
	var tick_after_leave := _tick
	await _wait_until(func() -> bool: return _tick > tick_after_leave + 5)
	_pass()


func _role_b() -> void:
	await _wait_until(func() -> bool: return _players.size() >= 2 and _confirmations > 0) # a coletou
	var me := get_multiplayer().get_unique_id()

	# 1. cesto já coletado: recusa
	var reply := await _request_collect("Basket")
	if not _expect(reply == Interaction.ALREADY_TAKEN, "recoleta deveria recusar '%s', veio '%s'" % [Interaction.ALREADY_TAKEN, reply]):
		return

	# 2. objeto que não existe: recusa
	await create_timer(0.4).timeout
	reply = await _request_collect("Nada")
	if not _expect(reply == Interaction.NOT_FOUND, "inexistente deveria recusar '%s', veio '%s'" % [Interaction.NOT_FOUND, reply]):
		return

	# 3. entrada adulterada (vetor gigante): a velocidade continua limitada
	var start: Vector3 = _players[me]
	var start_tick := _tick
	for i in 60:
		_session.send_input.rpc_id(1, Vector2(500.0, -500.0), 0.0)
		await physics_frame
	var end: Vector3 = _players[me]
	var seconds := float(_tick - start_tick) / float(Engine.physics_ticks_per_second)
	var moved := Vector2(end.x - start.x, end.z - start.z).length()
	if not _expect(moved > 1.0, "o jogador deveria ter se movido (moveu %.2f m)" % moved):
		return
	if not _expect(moved / seconds <= Movement.SPEED * 1.05, "velocidade %.1f m/s acima do limite %.1f" % [moved / seconds, Movement.SPEED]):
		return

	# 4. mensagens inválidas são ignoradas: o servidor continua respondendo com posições válidas
	_session.send_input.rpc_id(1, Vector2(NAN, NAN), INF)
	_session.send_input.rpc_id(1, "x", null)
	_session.request_collect.rpc_id(1, 123)
	_session.request_collect.rpc_id(1, "x".repeat(1000))
	var tick_before := _tick
	await _wait_until(func() -> bool: return _tick > tick_before + 5)
	var p: Vector3 = _players[me]
	if not _expect(is_finite(p.x) and is_finite(p.y) and is_finite(p.z), "posição ficou inválida: %s" % p):
		return
	_pass()



## Colhe e entrega a sua metade de cada missão, na ordem (colheita, transporte, armazéns), e espera todas concluírem.
func _role_worker(part: int) -> void:
	_side = 0.9 if part == 0 else -0.9
	var me := get_multiplayer().get_unique_id()
	await _wait_until(func() -> bool: return _players.has(me))
	for id in _ids_with_prefix("Trigo", part):
		if not await _collect(id):
			return
	await _wait_until(func() -> bool: return _mission_done.get("colheita", false))
	if not await _carry_and_deliver("Saco", "Celeiro", part):
		return
	await _wait_until(func() -> bool: return _mission_done.get("transporte", false))
	if not await _carry_and_deliver("Jarro", "Armazem", part):
		return
	await _wait_until(func() -> bool: return _all_done())
	var expected := {"colheita": Vector2i(10, 10), "transporte": Vector2i(6, 6), "armazens": Vector2i(6, 6)}
	if _expect(_mission_progress == expected, "progresso final errado: %s" % [_mission_progress]):
		_pass()


func _carry_and_deliver(prefix: String, zone: String, part: int) -> bool:
	var mine := _ids_with_prefix(prefix, part)
	for id in mine:
		if not await _collect(id):
			return false
	await _walk_to(_level_position(zone))
	for id in mine:
		await create_timer(0.4).timeout
		var reply := await _request_deliver(zone)
		if not _expect(reply == ACCEPTED, "entrega em %s deveria ser aceita, veio '%s'" % [zone, reply]):
			return false
	return true


## Entra depois da conclusão e já deve receber todas as missões concluídas.
func _role_late() -> void:
	await _wait_until(func() -> bool: return _all_done())
	_pass()


func _all_done() -> bool:
	return _mission_done.get("colheita", false) and _mission_done.get("transporte", false) and _mission_done.get("armazens", false)


func _collect(id: String) -> bool:
	await _walk_to(_level_position(id))
	await create_timer(0.4).timeout
	var reply := await _request_collect(id)
	return _expect(reply == ACCEPTED, "%s deveria ser aceito, veio '%s'" % [id, reply])


## Pede a entrega; ACCEPTED se o servidor confirmou, senão o motivo da recusa.
func _request_deliver(zone: String) -> String:
	var baseline := _deliveries
	_denied = ""
	_session.request_deliver.rpc_id(1, zone)
	await _wait_until(func() -> bool: return _denied != "" or _deliveries > baseline)
	return _denied if _denied != "" else ACCEPTED


## Ids do nível com o prefixo, só os de índice par ou ímpar.
func _ids_with_prefix(prefix: String, part: int) -> Array[String]:
	var all := _level_ids(prefix)
	var mine: Array[String] = []
	for i in all.size():
		if i % 2 == part:
			mine.append(all[i])
	return mine


func _walk_to(target: Vector3) -> void:
	target += Vector3(_side, 0, 0) # um de cada lado, para um não travar o outro
	var me := get_multiplayer().get_unique_id()
	while not _done and (_players[me] as Vector3).distance_to(target) > Interaction.REACH - 0.8:
		var to: Vector3 = target - (_players[me] as Vector3)
		_session.send_input.rpc_id(1, Vector2(to.x, to.z).normalized(), 0.0)
		await physics_frame
	_session.send_input.rpc_id(1, Vector2.ZERO, 0.0)


func _level_ids(prefix: String) -> Array[String]:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var objects := {}
	for node in level.get_children():
		objects[str(node.name)] = Vector3.ZERO
	level.free()
	return Mission.required(objects, prefix)


func _level_position(id: String) -> Vector3:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var position: Vector3 = (level.get_node(id) as Node3D).position
	level.free()
	return position


func _on_mission(mission: String, collected: int, target: int, done: bool) -> void:
	_mission_progress[mission] = Vector2i(collected, target)
	_mission_done[mission] = done


## Envia o pedido e espera a resposta: o motivo da recusa, ou ACCEPTED se o servidor confirmou a coleta.
func _request_collect(id: Variant) -> String:
	var baseline := _confirmations
	_denied = ""
	_session.request_collect.rpc_id(1, id)
	await _wait_until(func() -> bool: return _denied != "" or _confirmations > baseline)
	return _denied if _denied != "" else ACCEPTED


func _on_state(tick: int, players: Dictionary) -> void:
	_tick = tick
	_players = players


func _on_confirmed(_id: String, by: int) -> void:
	_confirmations += 1
	_confirmed_by = by


func _on_denied(_id: String, reason: String) -> void:
	_denied = reason


func _wait_until(condition: Callable) -> void:
	while not _done and not condition.call():
		await process_frame


func _basket_position() -> Vector3:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var position: Vector3 = (level.get_node("Basket") as Node3D).position
	level.free()
	return position


func _other_peer(me: int) -> int:
	for peer in _players:
		if peer != me:
			return peer
	return 0


func _expect(condition: bool, message: String) -> bool:
	if not condition:
		_fail(message)
	return condition


func _fail(message: String) -> void:
	if _done:
		return
	_done = true
	printerr("FALHOU: %s" % message)
	quit(1)


func _pass() -> void:
	if _done:
		return
	_done = true
	print("bot ok")
	quit(0)


