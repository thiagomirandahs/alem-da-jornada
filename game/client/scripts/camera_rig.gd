extends Node3D
## Câmera em terceira pessoa. O mouse gira (yaw) e inclina (pitch) o pivô. Deve ser filha do personagem.

const MOUSE_SENSITIVITY := 0.003
const PITCH_MIN := -1.2 # câmera alta, olhando para baixo
const PITCH_MAX := 0.4 # câmera baixa, olhando para cima


func _ready() -> void:
	# a câmera não deve colidir com o próprio personagem (só existe quando ele tem corpo físico)
	var body := get_parent() as CollisionObject3D
	if body != null:
		$SpringArm.add_excluded_object(body.get_rid())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion := (event as InputEventMouseMotion).relative * MOUSE_SENSITIVITY
		rotation.y -= motion.x
		rotation.x = clampf(rotation.x - motion.y, PITCH_MIN, PITCH_MAX)
