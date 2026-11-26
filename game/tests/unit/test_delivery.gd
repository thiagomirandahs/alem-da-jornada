extends RefCounted

const ZONES := {"Celeiro": Vector3(0, 1, 18)}


func test_perto_e_com_carga_aceita() -> String:
	return _expect("", Delivery.check(Vector3(0, 0, 16), ZONES, "Celeiro", "Celeiro", ["Saco01"]))


func test_longe_recusa() -> String:
	return _expect(Delivery.TOO_FAR, Delivery.check(Vector3(0, 0, 0), ZONES, "Celeiro", "Celeiro", ["Saco01"]))


func test_sem_carga_recusa_mesmo_perto() -> String:
	return _expect(Delivery.NOT_CARRYING, Delivery.check(Vector3(0, 0, 17), ZONES, "Celeiro", "Celeiro", []))


func test_zona_errada_recusa() -> String:
	return _expect(Delivery.WRONG_ZONE, Delivery.check(Vector3(0, 0, 17), {"Celeiro": Vector3(0, 1, 18), "Armazem": Vector3(0, 1, 17)}, "Armazem", "Celeiro", ["Saco01"]))


func test_zona_inexistente_recusa() -> String:
	return _expect(Delivery.NO_ZONE, Delivery.check(Vector3(0, 0, 17), ZONES, "Nada", "Celeiro", ["Saco01"]))


func test_carrega_so_o_que_coletou_e_nao_entregou() -> String:
	var taken := {"Saco02": 7, "Saco01": 7, "Saco03": 9, "Trigo01": 7}
	var carried := Delivery.carried_by(7, "Saco", taken, {"Saco02": 7})
	return "" if carried == ["Saco01"] else "esperado [Saco01], obtido %s" % [carried]


func test_missao_ativa_e_a_primeira_nao_concluida() -> String:
	if Mission.active_index([true, false]) != 1 or Mission.active_index([false, false]) != 0:
		return "índice ativo errado"
	return "" if Mission.active_index([true, true]) == 2 else "todas concluídas deveria dar 2"


func _expect(expected: String, actual: String) -> String:
	return "" if expected == actual else "esperado '%s', obtido '%s'" % [expected, actual]
