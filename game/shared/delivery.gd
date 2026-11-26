class_name Delivery
extends RefCounted
## Regra de entrega (ADR-0003, ADR-0010): só o servidor decide, com a posição que ele mesmo calculou.

const REACH := 3.0
const NO_ZONE := "inexistente"
const TOO_FAR := "longe"
const NOT_CARRYING := "sem_carga"
const WRONG_ZONE := "zona_errada"
const NO_MISSION := "sem_missao"


## Retorna "" se pode entregar; senão, o motivo. expected_zone: a zona da missão ativa. zones: id -> posição. carried: ids que o jogador carrega.
static func check(player_pos: Vector3, zones: Dictionary, zone_id: String, expected_zone: String, carried: Array) -> String:
	if not zones.has(zone_id):
		return NO_ZONE
	if zone_id != expected_zone:
		return WRONG_ZONE
	if player_pos.distance_to(zones[zone_id]) > REACH:
		return TOO_FAR
	if carried.is_empty():
		return NOT_CARRYING
	return ""


## Ids que o jogador carrega: coletou (taken: id -> peer) e ainda não entregou (delivered: id -> peer), só do prefixo.
static func carried_by(peer: int, prefix: String, taken: Dictionary, delivered: Dictionary) -> Array[String]:
	var ids: Array[String] = []
	for id in taken:
		if str(id).begins_with(prefix) and taken[id] == peer and not delivered.has(id):
			ids.append(str(id))
	ids.sort()
	return ids
