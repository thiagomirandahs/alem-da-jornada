extends Node3D
## Cliente de rede (ADR-0003, ADR-0008): envia comandos e mostra o estado que o servidor manda.
## Uso: godot --path game res://client/scenes/net_client.tscn -- [--connect=127.0.0.1:7777]

const AVATAR := preload("res://client/scenes/avatar.tscn")
const CAMERA_RIG := preload("res://client/scenes/camera_rig.tscn")
const SMOOTHING := 25.0 # só suaviza o desenho entre dois estados; não prevê nada

var _avatars: Dictionary = {} # peer -> Node3D
var _targets: Dictionary = {} # peer -> último Vector3 recebido do servidor
var _rig: Node3D # câmera do jogador local; só existe depois do primeiro estado
var _message := ""
var _mission := ""

@onready var _session: Session = $Session
@onready var _label: Label = $Hud/Label


func _ready() -> void:
	var address := CmdArgs.value(OS.get_cmdline_user_args(), "connect", "127.0.0.1:%d" % Session.PORT)
	var parts := address.rsplit(":", true, 1)
	var peer := ENetMultiplayerPeer.new()
	if parts.size() != 2 or not parts[1].is_valid_int() or peer.create_client(parts[0], parts[1].to_int()) != OK:
		_quit("ERRO: use --connect=ip:porta (recebido '%s')" % address)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.connection_failed.connect(_quit.bind("ERRO: não foi possível conectar a %s" % address))
	multiplayer.server_disconnected.connect(_quit.bind("O servidor desconectou"))
	_session.state_received.connect(_on_state)
	_session.collect_confirmed.connect(_on_collected)
	_session.collect_denied.connect(_on_denied)
	_session.mission_updated.connect(_on_mission)
	_message = "Conectando a %s..." % address
	_update_hud()


func _physics_process(_delta: float) -> void:
	if _rig != null:
		var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		_session.send_input.rpc_id(1, input, _rig.rotation.y)


func _process(delta: float) -> void:
	for peer in _avatars:
		var avatar: Node3D = _avatars[peer]
		avatar.position = avatar.position.lerp(_targets[peer], 1.0 - exp(-SMOOTHING * delta))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _rig != null:
		var id := _nearest_collectable_id()
		if not id.is_empty():
			_session.request_collect.rpc_id(1, id)


func _on_state(_tick: int, players: Dictionary) -> void:
	var me := multiplayer.get_unique_id()
	for peer in players:
		if not _avatars.has(peer):
			_spawn(peer, players[peer], peer == me)
		_targets[peer] = players[peer]
	for peer in _avatars.keys():
		if not players.has(peer):
			_avatars[peer].queue_free()
			_avatars.erase(peer)
			_targets.erase(peer)
	_update_hud()


func _spawn(peer: int, position_now: Vector3, is_local: bool) -> void:
	var avatar: Node3D = AVATAR.instantiate()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.5, 0.9) if is_local else Color(0.9, 0.5, 0.2)
	(avatar.get_node("Body") as MeshInstance3D).material_override = material
	avatar.position = position_now
	$Avatars.add_child(avatar)
	_avatars[peer] = avatar
	if is_local:
		_rig = CAMERA_RIG.instantiate()
		avatar.add_child(_rig)
		_message = "Conectado."


func _on_collected(id: String, by: int) -> void:
	var node := $Level.get_node_or_null(NodePath(id))
	if node != null and node.is_in_group("collectable"):
		node.queue_free()
	_message = "Você coletou %s" % id if by == multiplayer.get_unique_id() else "Jogador %d coletou %s" % [by, id]
	_update_hud()


func _on_denied(id: String, reason: String) -> void:
	_message = "Servidor recusou a coleta de %s: %s" % [id, reason]
	_update_hud()


func _nearest_collectable_id() -> String:
	var here: Vector3 = (_avatars[multiplayer.get_unique_id()] as Node3D).position
	var best := ""
	var best_distance := INF
	for node in get_tree().get_nodes_in_group("collectable"):
		var distance := here.distance_to((node as Node3D).global_position)
		if distance < best_distance:
			best = str(node.name)
			best_distance = distance
	return best


func _update_hud() -> void:
	_label.text = "Você: jogador %d | Jogadores: %d\nWASD: andar | mouse: câmera | E: coletar | Esc: soltar o mouse\n%s\n%s" % [
		multiplayer.get_unique_id(), _avatars.size(), _mission, _message]


func _quit(message: String) -> void:
	printerr(message)
	get_tree().quit(1)


func _on_mission(collected: int, target: int, done: bool) -> void:
	_mission = "Missão concluída!" if done else "Colheita: %d/%d" % [collected, target]
	_update_hud()
