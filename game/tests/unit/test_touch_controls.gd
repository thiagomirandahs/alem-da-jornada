extends RefCounted
## Dedos simulados contra o nó real dos controles de toque (sem aparelho).

var _screen := Vector2(1280, 720)


func test_joystick_emite_direcao_e_zera_ao_soltar() -> String:
	var rig := _rig()
	var at := Vector2(_screen.x * 0.2, _screen.y * 0.7)
	_touch(rig, 0, at, true)
	_drag(rig, 0, at + Vector2(TouchMath.JOYSTICK_RADIUS, 0))
	_drag(rig, 0, at + Vector2(TouchMath.JOYSTICK_RADIUS * 5.0, 0)) # além do raio: continua 1
	_touch(rig, 0, at, false)
	var got: Array = rig.log.moves
	_free(rig)
	return "" if got == [Vector2(1, 0), Vector2.ZERO] else "obtido %s" % [got]


func test_dedo_parado_na_zona_morta_nao_emite() -> String:
	var rig := _rig()
	var at := Vector2(_screen.x * 0.2, _screen.y * 0.7)
	_touch(rig, 0, at, true)
	_drag(rig, 0, at + Vector2(2, 1))
	var got: Array = rig.log.moves
	_free(rig)
	return "" if got.is_empty() else "obtido %s" % [got]


func test_giro_repassa_o_deslocamento_do_dedo() -> String:
	var rig := _rig()
	_touch(rig, 1, Vector2(_screen.x * 0.8, _screen.y * 0.3), true)
	_drag(rig, 1, Vector2(_screen.x * 0.8 + 12, _screen.y * 0.3 - 5), Vector2(12, -5))
	var got: Array = rig.log.looks
	_free(rig)
	return "" if got == [Vector2(12, -5)] else "obtido %s" % [got]


func test_botao_interagir_emite_uma_vez_por_toque() -> String:
	var rig := _rig()
	var button := TouchMath.interact_center(_screen)
	_touch(rig, 2, button, true)
	_touch(rig, 3, button, true) # segundo dedo no botão enquanto o primeiro segura: ignorado
	_touch(rig, 2, button, false)
	_touch(rig, 2, button, true)
	var count: int = rig.log.interacts
	_free(rig)
	return "" if count == 2 else "esperado 2, obtido %d" % count


func test_dois_dedos_ao_mesmo_tempo_nao_se_atrapalham() -> String:
	var rig := _rig()
	var at := Vector2(_screen.x * 0.2, _screen.y * 0.7)
	_touch(rig, 0, at, true) # joystick
	_touch(rig, 1, Vector2(_screen.x * 0.8, _screen.y * 0.3), true) # giro
	_drag(rig, 0, at + Vector2(0, -TouchMath.JOYSTICK_RADIUS))
	_drag(rig, 1, Vector2(_screen.x * 0.8 + 3, _screen.y * 0.3), Vector2(3, 0))
	_touch(rig, 1, Vector2.ZERO, false) # soltar o giro não pode zerar o joystick
	var moves: Array = rig.log.moves
	var looks: Array = rig.log.looks
	_free(rig)
	if moves != [Vector2(0, -1)] or looks != [Vector2(3, 0)]:
		return "moves=%s looks=%s" % [moves, looks]
	return ""


func _rig() -> Dictionary:
	var controls := TouchControls.new()
	controls.screen_size = _screen
	var root := (Engine.get_main_loop() as SceneTree).root
	root.add_child(controls)
	var log := {"moves": [], "looks": [], "interacts": 0}
	controls.moved.connect(func(v: Vector2) -> void: log.moves.append(v))
	controls.looked.connect(func(r: Vector2) -> void: log.looks.append(r))
	controls.interacted.connect(func() -> void: log.interacts += 1)
	return {"controls": controls, "log": log}


func _free(rig: Dictionary) -> void:
	(rig.controls as Node).free()


func _touch(rig: Dictionary, index: int, pos: Vector2, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = pos
	event.pressed = pressed
	(rig.controls as TouchControls)._input(event)


func _drag(rig: Dictionary, index: int, pos: Vector2, relative: Vector2 = Vector2.ZERO) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = pos
	event.relative = relative
	(rig.controls as TouchControls)._input(event)
