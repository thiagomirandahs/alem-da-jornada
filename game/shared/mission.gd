class_name Mission
extends RefCounted
## Missão 1, A grande colheita (PLANO_MESTRE §2.3): objetivo coletivo decidido só pelo servidor (ADR-0003).
## Regra pura: recebe o que o servidor já sabe (quem coletou o quê) e devolve o estado da missão.

# shortcut: os feixes da missão são os objetos do nível cujo nome começa assim; com a segunda missão, trocar por dados da missão.
const WHEAT_PREFIX := "Trigo"


## Ids que a missão exige, em ordem. objects: id -> posição dos objetos coletáveis do nível.
static func required(objects: Dictionary) -> Array[String]:
	var ids: Array[String] = []
	for id in objects:
		if str(id).begins_with(WHEAT_PREFIX):
			ids.append(str(id))
	ids.sort()
	return ids


## Quantos dos exigidos já foram coletados. taken: id -> peer que coletou.
static func progress(needed: Array[String], taken: Dictionary) -> int:
	var count := 0
	for id in needed:
		if taken.has(id):
			count += 1
	return count


## Sem objetivo não há missão a concluir.
static func is_done(needed: Array[String], taken: Dictionary) -> bool:
	return not needed.is_empty() and progress(needed, taken) == needed.size()


## Quanto cada jogador colheu (peer -> quantidade), só dos exigidos.
static func contributions(needed: Array[String], taken: Dictionary) -> Dictionary:
	var by_peer := {}
	for id in needed:
		if taken.has(id):
			by_peer[taken[id]] = int(by_peer.get(taken[id], 0)) + 1
	return by_peer
