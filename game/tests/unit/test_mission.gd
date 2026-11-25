extends RefCounted

const OBJECTS := {"Basket": Vector3(3, 0.3, 4), "Trigo02": Vector3(), "Trigo01": Vector3(), "Trigo03": Vector3()}


func test_exige_so_os_feixes_em_ordem() -> String:
	return _expect_ids(["Trigo01", "Trigo02", "Trigo03"], Mission.required(OBJECTS))


func test_o_cesto_nao_conta_para_a_missao() -> String:
	var needed := Mission.required(OBJECTS)
	return _expect_int(0, Mission.progress(needed, {"Basket": 7}))


func test_progresso_conta_feixes_de_todos_os_jogadores() -> String:
	var needed := Mission.required(OBJECTS)
	return _expect_int(2, Mission.progress(needed, {"Trigo01": 7, "Trigo03": 9, "Basket": 7}))


func test_conclui_so_quando_o_ultimo_feixe_e_coletado() -> String:
	var needed := Mission.required(OBJECTS)
	var two := {"Trigo01": 7, "Trigo02": 9}
	if Mission.is_done(needed, two):
		return "com 2 de 3 a missão não deveria estar concluída"
	two["Trigo03"] = 7
	return "" if Mission.is_done(needed, two) else "com 3 de 3 a missão deveria estar concluída"


func test_sem_objetivo_nao_conclui() -> String:
	return "" if not Mission.is_done(Mission.required({"Basket": Vector3()}), {}) else "missão sem feixes não pode concluir"


func test_contribuicao_por_jogador() -> String:
	var by_peer := Mission.contributions(Mission.required(OBJECTS), {"Trigo01": 7, "Trigo02": 9, "Trigo03": 7, "Basket": 9})
	return "" if by_peer == {7: 2, 9: 1} else "contribuições erradas: %s" % by_peer


func test_o_nivel_tem_dez_feixes_com_ids_unicos() -> String:
	var level := (load("res://shared/level.tscn") as PackedScene).instantiate()
	var objects := {}
	for node in level.get_children():
		if node.is_in_group("collectable"):
			if objects.has(str(node.name)):
				level.free()
				return "id repetido no nível: %s" % node.name
			objects[str(node.name)] = (node as Node3D).position
	level.free()
	var needed := Mission.required(objects)
	return "" if needed.size() == 10 else "o nível deveria ter 10 feixes, tem %d" % needed.size()


func _expect_ids(expected: Array, actual: Array[String]) -> String:
	return "" if expected == actual else "esperado %s, obtido %s" % [expected, actual]


func _expect_int(expected: int, actual: int) -> String:
	return "" if expected == actual else "esperado %d, obtido %d" % [expected, actual]
