class_name Interaction
extends RefCounted
## Regra de coleta (ADR-0003): quem decide é o servidor, com a posição que ele mesmo calculou.

const REACH := 2.5
const NOT_FOUND := "inexistente"
const ALREADY_TAKEN := "coletado"
const TOO_FAR := "longe"


## Retorna "" se o jogador pode coletar o objeto; senão, o motivo da recusa.
## objects: id -> posição de todos os objetos do nível. taken: ids já coletados (chaves).
static func check(player_pos: Vector3, objects: Dictionary, taken: Dictionary, id: String) -> String:
	if not objects.has(id):
		return NOT_FOUND
	if taken.has(id):
		return ALREADY_TAKEN
	if player_pos.distance_to(objects[id]) > REACH:
		return TOO_FAR
	return ""
