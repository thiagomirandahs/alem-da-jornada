class_name Movement
extends RefCounted
## Regras de movimentação compartilhadas por cliente e servidor (ADR-0003).

const SPEED := 5.0
const MAX_INPUT := 1000.0


## Aceita só entrada bem formada vinda da rede: tipos certos e números finitos (NaN contaminaria a posição).
static func valid_input(move: Variant, yaw: Variant) -> bool:
	return move is Vector2 and yaw is float \
		and is_finite(move.x) and is_finite(move.y) and is_finite(yaw) \
		and absf(move.x) <= MAX_INPUT and absf(move.y) <= MAX_INPUT


## Calcula a próxima velocidade. A entrada é limitada a comprimento 1,
## então um vetor adulterado não deixa o personagem mais rápido.
static func step(velocity: Vector3, input: Vector2, yaw: float, on_floor: bool, gravity: float, delta: float) -> Vector3:
	var direction := Vector3(input.x, 0.0, input.y).limit_length(1.0).rotated(Vector3.UP, yaw)
	var next := Vector3(direction.x * SPEED, velocity.y, direction.z * SPEED)
	if not on_floor:
		next.y -= gravity * delta
	return next
