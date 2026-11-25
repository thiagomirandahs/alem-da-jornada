class_name Session
extends Node
## Todas as mensagens da partida (ADR-0008). Este nó existe, em /root/Game/Session, no servidor e nos clientes.
## Aqui só se valida e se repassa por sinal; as decisões ficam em game/server/.

const PORT := 7777
const MAX_PLAYERS := 8
const MAX_ID_LENGTH := 32

# Chegam ao servidor
signal input_received(peer: int, move: Vector2, yaw: float)
signal collect_requested(peer: int, id: String)
signal deliver_requested(peer: int, zone: String)
# Chegam aos clientes
signal state_received(tick: int, players: Dictionary)
signal collect_confirmed(id: String, by: int)
signal collect_denied(id: String, reason: String)
signal mission_updated(mission: String, collected: int, target: int, done: bool)
signal delivery_confirmed(id: String, by: int)


## Cliente -> servidor. Só direção e giro: a posição é sempre calculada pelo servidor.
@rpc("any_peer", "call_remote", "unreliable_ordered")
func send_input(move: Variant, yaw: Variant) -> void:
	if multiplayer.is_server() and Movement.valid_input(move, yaw):
		input_received.emit(multiplayer.get_remote_sender_id(), move, yaw)


## Cliente -> servidor.
@rpc("any_peer", "call_remote", "reliable")
func request_collect(id: Variant) -> void:
	if multiplayer.is_server() and id is String and (id as String).length() <= MAX_ID_LENGTH:
		collect_requested.emit(multiplayer.get_remote_sender_id(), id)


## Servidor -> clientes: posição oficial de cada jogador (peer -> Vector3).
@rpc("authority", "call_remote", "unreliable_ordered")
func push_state(tick: int, players: Dictionary) -> void:
	state_received.emit(tick, players)


@rpc("authority", "call_remote", "reliable")
func push_collected(id: String, by: int) -> void:
	collect_confirmed.emit(id, by)


@rpc("authority", "call_remote", "reliable")
func push_denied(id: String, reason: String) -> void:
	collect_denied.emit(id, reason)


## Servidor -> clientes: progresso da missão (coletados, meta, concluída). Só o servidor decide a conclusão.
@rpc("authority", "call_remote", "reliable")
func push_mission(mission: String, collected: int, target: int, done: bool) -> void:
	mission_updated.emit(mission, collected, target, done)


## Cliente -> servidor: entregar o que carrega na zona (ex.: o celeiro). O servidor confere posição e carga.
@rpc("any_peer", "call_remote", "reliable")
func request_deliver(zone: Variant) -> void:
	if multiplayer.is_server() and zone is String and (zone as String).length() <= MAX_ID_LENGTH:
		deliver_requested.emit(multiplayer.get_remote_sender_id(), zone)


@rpc("authority", "call_remote", "reliable")
func push_delivered(id: String, by: int) -> void:
	delivery_confirmed.emit(id, by)
