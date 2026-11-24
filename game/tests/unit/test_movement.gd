extends RefCounted

const GRAVITY := 9.8
const DELTA := 1.0 / 60.0


func test_frente_com_camera_sem_giro_anda_em_menos_z() -> String:
	var v := Movement.step(Vector3.ZERO, Vector2(0, -1), 0.0, true, GRAVITY, DELTA)
	return _expect(v, Vector3(0, 0, -Movement.SPEED))


func test_frente_com_camera_girada_90_graus_anda_em_menos_x() -> String:
	var v := Movement.step(Vector3.ZERO, Vector2(0, -1), PI / 2, true, GRAVITY, DELTA)
	return _expect(v, Vector3(-Movement.SPEED, 0, 0))


func test_entrada_adulterada_nao_aumenta_velocidade() -> String:
	var v := Movement.step(Vector3.ZERO, Vector2(100, -100), 0.0, true, GRAVITY, DELTA)
	if v.length() > Movement.SPEED + 0.001:
		return "velocidade %s acima do limite %s" % [v.length(), Movement.SPEED]
	return ""


func test_sem_entrada_fica_parado() -> String:
	var v := Movement.step(Vector3(3, 0, 3), Vector2.ZERO, 0.0, true, GRAVITY, DELTA)
	return _expect(v, Vector3.ZERO)


func test_no_ar_aplica_gravidade() -> String:
	var v := Movement.step(Vector3(0, -1, 0), Vector2.ZERO, 0.0, false, GRAVITY, DELTA)
	return _expect(v, Vector3(0, -1 - GRAVITY * DELTA, 0))


func _expect(actual: Vector3, expected: Vector3) -> String:
	return "" if actual.is_equal_approx(expected) else "esperado %s, obtido %s" % [expected, actual]
