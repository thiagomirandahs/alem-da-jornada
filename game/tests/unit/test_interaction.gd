extends RefCounted

const OBJECTS := {"Basket": Vector3(3, 0.3, 4)}


func test_perto_aceita() -> String:
	return _expect("", Interaction.check(Vector3(3, 0, 2), OBJECTS, {}, "Basket"))


func test_longe_recusa() -> String:
	return _expect(Interaction.TOO_FAR, Interaction.check(Vector3(0, 0, 0), OBJECTS, {}, "Basket"))


func test_ja_coletado_recusa_mesmo_perto() -> String:
	return _expect(Interaction.ALREADY_TAKEN, Interaction.check(Vector3(3, 0, 4), OBJECTS, {"Basket": 7}, "Basket"))


func test_objeto_inexistente_recusa() -> String:
	return _expect(Interaction.NOT_FOUND, Interaction.check(Vector3(3, 0, 4), OBJECTS, {}, "Nada"))


func test_limite_do_alcance() -> String:
	var just_in := Vector3(3, 0.3, 4 - Interaction.REACH + 0.01)
	var just_out := Vector3(3, 0.3, 4 - Interaction.REACH - 0.01)
	return _expect("", Interaction.check(just_in, OBJECTS, {}, "Basket")) \
		+ _expect(Interaction.TOO_FAR, Interaction.check(just_out, OBJECTS, {}, "Basket"))


func _expect(expected: String, actual: String) -> String:
	return "" if expected == actual else "esperado '%s', obtido '%s'" % [expected, actual]
