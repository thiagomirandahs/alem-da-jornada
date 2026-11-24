extends Node3D
## Servidor da partida: dono do estado oficial (ADR-0003, ADR-0008). Sem tela.
## Uso: godot --headless --path game res://server/server_world.tscn -- [--port=7777] [--bind=127.0.0.1]

const COLLECT_COOLDOWN_MSEC := 300

var _bodies: Dictionary = {} # peer -> CharacterBody3D
var _inputs: Dictionary = {} # peer -> {"move": Vector2, "yaw": float}, só o último vale
var _objects: Dictionary = {} # id -> posição dos itens coletáveis do nível
var _taken: Dictionary = {} # id -> peer que coletou
var _last_collect: Dictionary = {} # peer -> instante do último pedido (ms)
var _spawned := 0
var _tick := 0
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _session: Session = $Session
@onready var _players: Node3D = $Players


func _ready() -> void:
	Engine.max_fps = 60 # sem tela, girar mais rápido que a física só gasta CPU
	var args := OS.get_cmdline_user_args()
	var port := CmdArgs.value(args, "port", str(Session.PORT)).to_int()
	var peer := ENetMultiplayerPeer.new()
	peer.set_bind_ip(CmdArgs.value(args, "bind", "127.0.0.1")) # exposição em rede só se pedida
	if port < 1024 or port > 65535 or peer.create_server(port, Session.MAX_PLAYERS) != OK:
		printerr("ERRO: não foi possível abrir a porta %s" % CmdArgs.value(args, "port", str(Session.PORT)))
		get_tree().quit(1)
		return
	multiplayer.multiplayer_peer = peer
	(multiplayer as SceneMultiplayer).server_relay = false # clientes não falam entre si
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_session.input_received.connect(_on_input)
	_session.collect_requested.connect(_on_collect_requested)
	for node in get_tree().get_nodes_in_group("collectable"):
		_objects[str(node.name)] = (node as Node3D).global_position
	print("servidor pronto na porta %d" % port)


func _physics_process(delta: float) -> void:
	var positions := {}
	for peer in _bodies:
		var body: CharacterBody3D = _bodies[peer]
		var input: Dictionary = _inputs.get(peer, {"move": Vector2.ZERO, "yaw": 0.0})
		body.velocity = Movement.step(body.velocity, input.move, input.yaw, body.is_on_floor(), _gravity, delta)
		body.move_and_slide()
		positions[peer] = body.position
	if positions.is_empty():
		return
	_tick += 1
	_session.push_state.rpc(_tick, positions)


func _on_peer_connected(peer: int) -> void:
	var body := CharacterBody3D.new()
	var shape := CollisionShape3D.new()
	shape.shape = CapsuleShape3D.new()
	shape.position.y = 1.0
	body.add_child(shape)
	_players.add_child(body)
	body.position = Vector3(float(_spawned % Session.MAX_PLAYERS) * 1.2 - 4.2, 0.1, 2.0)
	_spawned += 1
	_bodies[peer] = body
	for id in _taken: # quem entra depois também precisa saber o que já foi coletado
		_session.push_collected.rpc_id(peer, id, _taken[id])
	print("jogador %d entrou (%d/%d)" % [peer, _bodies.size(), Session.MAX_PLAYERS])


func _on_peer_disconnected(peer: int) -> void:
	if _bodies.has(peer):
		_bodies[peer].queue_free()
	_bodies.erase(peer)
	_inputs.erase(peer)
	_last_collect.erase(peer)
	print("jogador %d saiu (%d/%d)" % [peer, _bodies.size(), Session.MAX_PLAYERS])


func _on_input(peer: int, move: Vector2, yaw: float) -> void:
	if _bodies.has(peer):
		_inputs[peer] = {"move": move, "yaw": yaw}


func _on_collect_requested(peer: int, id: String) -> void:
	if not _bodies.has(peer):
		return
	var now := Time.get_ticks_msec()
	if now - int(_last_collect.get(peer, -COLLECT_COOLDOWN_MSEC)) < COLLECT_COOLDOWN_MSEC:
		_session.push_denied.rpc_id(peer, id, "rapido")
		return
	_last_collect[peer] = now
	var reason := Interaction.check((_bodies[peer] as CharacterBody3D).position, _objects, _taken, id)
	if reason.is_empty():
		_taken[id] = peer
		_session.push_collected.rpc(id, peer)
		print("jogador %d coletou %s" % [peer, id])
	else:
		_session.push_denied.rpc_id(peer, id, reason)
		print("jogador %d recusado em %s: %s" % [peer, id, reason])
