class_name TouchMath
extends RefCounted
## Contas dos controles de toque, sem nós, para poderem ser testadas. Medidas em pixels da tela base.

enum Region { MOVE, LOOK, INTERACT }

const JOYSTICK_RADIUS := 100.0
const DEAD_ZONE := 0.1
const INTERACT_RADIUS := 60.0
const INTERACT_OFFSET := 110.0 # do canto inferior direito até o centro do botão
const MOVE_AREA := 0.45 # fração da largura, à esquerda, onde nasce o joystick
const LOOK_SENSITIVITY := 0.004 # rad por pixel arrastado


## Vetor do joystick, de comprimento 0 a 1, para um dedo em `touch` com o joystick nascido em `origin`.
## Dentro da zona morta, zero. Passando do raio, o comprimento fica em 1.
static func joystick(origin: Vector2, touch: Vector2, radius: float = JOYSTICK_RADIUS, dead_zone: float = DEAD_ZONE) -> Vector2:
	var vector := (touch - origin) / radius
	if vector.length() < dead_zone:
		return Vector2.ZERO
	return vector.limit_length(1.0)


static func interact_center(screen: Vector2) -> Vector2:
	return screen - Vector2(INTERACT_OFFSET, INTERACT_OFFSET)


## Para onde vai um dedo que encostou em `pos`: botão de interagir, joystick (esquerda) ou giro da câmera (resto).
static func region(pos: Vector2, screen: Vector2) -> Region:
	if pos.distance_to(interact_center(screen)) <= INTERACT_RADIUS:
		return Region.INTERACT
	if pos.x < screen.x * MOVE_AREA:
		return Region.MOVE
	return Region.LOOK
