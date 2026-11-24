extends CharacterBody3D
## Personagem local: lê o teclado, move com as regras de Movement e gira a câmera com o mouse.

const MOUSE_SENSITIVITY := 0.003
const PITCH_MIN := -1.2 # câmera alta, olhando para baixo
const PITCH_MAX := 0.4 # câmera baixa, olhando para cima

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _pivot: Node3D = $CameraPivot
@onready var _spring_arm: SpringArm3D = $CameraPivot/SpringArm


func _ready() -> void:
	_spring_arm.add_excluded_object(get_rid())


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity = Movement.step(velocity, input, _pivot.rotation.y, is_on_floor(), _gravity, delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion := (event as InputEventMouseMotion).relative * MOUSE_SENSITIVITY
		_pivot.rotation.y -= motion.x
		_pivot.rotation.x = clampf(_pivot.rotation.x - motion.y, PITCH_MIN, PITCH_MAX)
