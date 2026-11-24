class_name Movement
extends RefCounted
## Regras de movimentação compartilhadas por cliente e servidor (ADR-0003).

const SPEED := 5.0


## Calcula a próxima velocidade. A entrada é limitada a comprimento 1,
## então um vetor adulterado não deixa o personagem mais rápido.
static func step(velocity: Vector3, input: Vector2, yaw: float, on_floor: bool, gravity: float, delta: float) -> Vector3:
	var direction := Vector3(input.x, 0.0, input.y).limit_length(1.0).rotated(Vector3.UP, yaw)
	var next := Vector3(direction.x * SPEED, velocity.y, direction.z * SPEED)
	if not on_floor:
		next.y -= gravity * delta
	return next
