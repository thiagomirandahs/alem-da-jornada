extends SceneTree
## Cliente de teste sem interface (ADR-0008). Fala com o servidor só pelo protocolo da Session,
## como faria um cliente adulterado. Papéis:
##   a: pede de longe (recusado), anda até o cesto e coleta; espera b sair (servidor continua vivo).
##   b: tenta coletar o que já foi coletado, um objeto inexistente, envia entrada adulterada e mensagens inválidas.
##   w0 e w1: colhem metade dos feixes de trigo cada um até a missão concluir; late entra depois e vê a missão concluída.
## Uso: godot --headless --path game -s res://tests/integration/bot.gd -- --role=a --port=17777

const TIMEOUT_SEC := 30.0
const ACCEPTED := "aceito"

var _session: Session
var _players: Dictionary = {} # peer -> Vector3, último estado recebido
var _tick := 0
var _confirmations := 0
var _confirmed_by := 0
var _denied := ""
var _mission_collected := 0
var _mission_target := 0
var _mission_done := false
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



## Colhe os feixes de índice par (part=0) ou ímpar (part=1) e espera a missão concluir.
func _role_worker(part: int) -> void:
	var me := get_multiplayer().get_unique_id()
	await _wait_until(func() -> bool: return _players.has(me))
	var ids := _wheat_ids()
	for i in ids.size():
		if i % 2 != part:
			continue
		var target := _level_position(ids[i])
		await _walk_to(target)
		await create_timer(0.4).timeout
		var reply := await _request_collect(ids[i])
		if not _expect(reply == ACCEPTED, "%s deveria ser aceito, veio '%s'" % [ids[i], reply]):
			return
	await _wait_until(func() -> bool: return _mission_done)
	if _expect(_mission_collected == ids.size() and _mission_target == ids.size(), "progresso final %d/%d, esperado %d" % [_mission_collected, _mission_target, ids.size()]):
		_pass()


## Entra depois da conclusão e já deve receber a missão concluída.
func _role_late() -> void:
	await _wait_until(func() -> bool: return _mission_done)
	if _expect(_mission_collected == _mission_target and _mission_target > 0, "quem entra depois deveria ver a missão concluída"):
		_pass()


func _walk_to(target: Vector3) -> void:
	var me := get_multiplayer().get_unique_id()
	while not _done and (_players[me] as Vector3).distance_to(target) > Interaction.REACH - 0.8:
		var to: Vector3 = target - (_players[me] as Vector3)
		_session.send_input.rpc_id(1, Vector2(to.x, to.z).normalized(), 0.0)
		await physics_frame
	_session.send_input.rpc_id(1, Vector2.ZERO, 0.0)


func _wheat_ids() -> Array[String]:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var objects := {}
	for node in level.get_children():
		objects[str(node.name)] = (node as Node3D).position if node is Node3D else Vector3.ZERO
	level.free()
	return Mission.required(objects)


func _level_position(id: String) -> Vector3:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var position: Vector3 = (level.get_node(id) as Node3D).position
	level.free()
	return position


func _on_mission(collected: int, target: int, done: bool) -> void:
	_mission_collected = collected
	_mission_target = target
	_mission_done = done
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
