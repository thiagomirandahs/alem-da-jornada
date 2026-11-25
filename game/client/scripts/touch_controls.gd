class_name TouchControls
extends Control
## Controles de toque: joystick flutuante à esquerda, botão Interagir no canto direito e giro da câmera
## arrastando o resto da tela. Só emitem os mesmos comandos do teclado e do mouse; o servidor decide tudo.

signal moved(vector: Vector2) # direção do joystick, comprimento de 0 a 1
signal looked(relative: Vector2) # arrasto do dedo, em pixels
signal interacted

## Tamanho da tela em pixels. Zero (o normal) usa o do viewport; os testes sem janela definem o seu.
var screen_size := Vector2.ZERO

var _move_finger := -1
var _move_origin := Vector2.ZERO
var _move_vector := Vector2.ZERO
var _look_finger := -1
var _interact_finger := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_on_touch(event as InputEventScreenTouch)
	elif event is InputEventScreenDrag:
		_on_drag(event as InputEventScreenDrag)


func _on_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		match TouchMath.region(event.position, _screen()):
			TouchMath.Region.MOVE:
				if _move_finger == -1:
					_move_finger = event.index
					_move_origin = event.position
			TouchMath.Region.LOOK:
				if _look_finger == -1:
					_look_finger = event.index
			TouchMath.Region.INTERACT:
				if _interact_finger == -1:
					_interact_finger = event.index
					interacted.emit()
	elif event.index == _move_finger:
		_move_finger = -1
		_set_move(Vector2.ZERO)
	elif event.index == _look_finger:
		_look_finger = -1
	elif event.index == _interact_finger:
		_interact_finger = -1
	queue_redraw()


func _on_drag(event: InputEventScreenDrag) -> void:
	if event.index == _move_finger:
		_set_move(TouchMath.joystick(_move_origin, event.position))
	elif event.index == _look_finger:
		looked.emit(event.relative)
	queue_redraw()


func _set_move(vector: Vector2) -> void:
	if vector != _move_vector:
		_move_vector = vector
		moved.emit(vector)


func _screen() -> Vector2:
	return screen_size if screen_size != Vector2.ZERO else get_viewport_rect().size


func _draw() -> void:
	var button := TouchMath.interact_center(_screen())
	_draw_pad(button, TouchMath.INTERACT_RADIUS, 0.55 if _interact_finger != -1 else 0.35)
	var font := ThemeDB.fallback_font
	var text_at := button + Vector2(-TouchMath.INTERACT_RADIUS, 8)
	var text_width := TouchMath.INTERACT_RADIUS * 2.0
	draw_string_outline(font, text_at, "Interagir", HORIZONTAL_ALIGNMENT_CENTER, text_width, 20, 6, Color.BLACK)
	draw_string(font, text_at, "Interagir", HORIZONTAL_ALIGNMENT_CENTER, text_width, 20)
	if _move_finger != -1:
		_draw_pad(_move_origin, TouchMath.JOYSTICK_RADIUS, 0.3)
		draw_circle(_move_origin + _move_vector * TouchMath.JOYSTICK_RADIUS, 40.0, Color(1, 1, 1, 0.7))


# Fundo escuro e anel branco: aparece tanto sobre o chão claro quanto sobre o céu.
func _draw_pad(center: Vector2, radius: float, fill_alpha: float) -> void:
	draw_circle(center, radius, Color(0, 0, 0, fill_alpha))
	draw_arc(center, radius, 0.0, TAU, 48, Color(1, 1, 1, 0.85), 3.0)
