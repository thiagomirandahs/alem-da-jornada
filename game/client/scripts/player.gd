extends CharacterBody3D
## Personagem offline (cena de teste): lê o teclado e move com as regras de Movement.
## A câmera e o mouse ficam em camera_rig.gd.

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _pivot: Node3D = $CameraPivot


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity = Movement.step(velocity, input, _pivot.rotation.y, is_on_floor(), _gravity, delta)
	move_and_slide()
