class_name CameraRig
extends Node3D
## Câmera em terceira pessoa. Mouse ou toque giram (yaw) e inclinam (pitch) o pivô. Deve ser filha do personagem.

const MOUSE_SENSITIVITY := 0.003
const PITCH_MIN := -1.2 # câmera alta, olhando para baixo
const PITCH_MAX := 0.4 # câmera baixa, olhando para cima


func _ready() -> void:
	# a câmera não deve colidir com o próprio personagem (só existe quando ele tem corpo físico)
	var body := get_parent() as CollisionObject3D
	if body != null:
		$SpringArm.add_excluded_object(body.get_rid())


## Gira pelo deslocamento `relative` (pixels) vezes `sensitivity` (rad por pixel).
func look(relative: Vector2, sensitivity: float = MOUSE_SENSITIVITY) -> void:
	rotation.y -= relative.x * sensitivity
	rotation.x = clampf(rotation.x - relative.y * sensitivity, PITCH_MIN, PITCH_MAX)


func _unhandled_input(event: InputEvent) -> void:
	if OS.has_feature("mobile"):
		return # o toque já vira "olhar" nos controles de toque; o mouse emulado pelo toque giraria em dobro
	if event is InputEventMouseButton and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look((event as InputEventMouseMotion).relative)
