extends SceneTree
## Cliente de carga (issue #5): conecta e anda em direções variadas por --seconds, com entrada válida
## (a mesma taxa de um jogador: 1 mensagem por tick). Sem interface.
## Uso: godot --headless --path game -s res://tests/performance/walker.gd -- --port=17800 --seconds=60 --seed=1

const ARENA_RADIUS := 15.0 # o chão tem 40 m de lado; passando disso, volta para o centro

var _session: Session
var _rng := RandomNumberGenerator.new()
var _position := Vector3.ZERO
var _connected := false
var _direction := Vector2.ZERO
var _ticks := 0


func _initialize() -> void:
	Engine.max_fps = 60
	var args := OS.get_cmdline_user_args()
	var port := CmdArgs.value(args, "port", str(Session.PORT)).to_int()
	var seconds := CmdArgs.value(args, "seconds", "60").to_float()
	_rng.seed = CmdArgs.value(args, "seed", "1").to_int()
	var game := Node.new()
	game.name = "Game"
	_session = Session.new()
	_session.name = "Session"
	game.add_child(_session)
	root.add_child(game)
	_session.state_received.connect(_on_state)
	var peer := ENetMultiplayerPeer.new()
	if peer.create_client("127.0.0.1", port) != OK:
		printerr("FALHOU: não foi possível iniciar o cliente")
		quit(1)
		return
	get_multiplayer().multiplayer_peer = peer
	get_multiplayer().server_disconnected.connect(func() -> void:
		printerr("FALHOU: o servidor desconectou")
		quit(1))
	create_timer(seconds).timeout.connect(quit)
	physics_frame.connect(_on_physics_frame)


func _on_state(_tick: int, players: Dictionary) -> void:
	_connected = true
	var mine: Variant = players.get(get_multiplayer().get_unique_id())
	if mine is Vector3:
		_position = mine


func _on_physics_frame() -> void:
	if not _connected:
		return
	_ticks += 1
	if _ticks % 60 == 1:
		_direction = Vector2.from_angle(_rng.randf_range(0.0, TAU))
	var heading := _direction
	if Vector2(_position.x, _position.z).length() > ARENA_RADIUS:
		heading = -Vector2(_position.x, _position.z).normalized()
	_session.send_input.rpc_id(1, heading, 0.0)
