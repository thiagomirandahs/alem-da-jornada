extends RefCounted

const SCREEN := Vector2(1280, 720)


func test_joystick_dentro_da_zona_morta_e_zero() -> String:
	return _expect(Vector2.ZERO, TouchMath.joystick(Vector2(200, 500), Vector2(205, 503)))


func test_joystick_no_raio_da_vetor_unitario() -> String:
	return _expect(Vector2(1, 0), TouchMath.joystick(Vector2(200, 500), Vector2(200 + TouchMath.JOYSTICK_RADIUS, 500)))


func test_joystick_passando_do_raio_nao_passa_de_1() -> String:
	var v := TouchMath.joystick(Vector2(200, 500), Vector2(200 + 5000, 500 - 5000))
	return "" if v.length() <= 1.0 + 0.0001 and v.x > 0.0 and v.y < 0.0 else "obtido %s" % v


func test_joystick_na_metade_do_raio() -> String:
	return _expect(Vector2(0, -0.5), TouchMath.joystick(Vector2(200, 500), Vector2(200, 500 - TouchMath.JOYSTICK_RADIUS / 2.0)))


func test_regioes_da_tela() -> String:
	var button := TouchMath.interact_center(SCREEN)
	var got := [
		TouchMath.region(Vector2(100, 600), SCREEN), # esquerda: joystick
		TouchMath.region(Vector2(900, 300), SCREEN), # direita: giro
		TouchMath.region(button, SCREEN), # botão: interagir
		TouchMath.region(button + Vector2(TouchMath.INTERACT_RADIUS - 1.0, 0), SCREEN),
		TouchMath.region(button + Vector2(TouchMath.INTERACT_RADIUS + 5.0, 0), SCREEN), # logo fora do botão: giro
		TouchMath.region(Vector2(SCREEN.x * TouchMath.MOVE_AREA + 1.0, 100), SCREEN), # logo depois do limite: giro
	]
	var want := [TouchMath.Region.MOVE, TouchMath.Region.LOOK, TouchMath.Region.INTERACT, TouchMath.Region.INTERACT, TouchMath.Region.LOOK, TouchMath.Region.LOOK]
	return "" if got == want else "obtido %s, esperado %s" % [got, want]


func _expect(expected: Vector2, actual: Vector2) -> String:
	return "" if expected.is_equal_approx(actual) else "esperado %s, obtido %s" % [expected, actual]
