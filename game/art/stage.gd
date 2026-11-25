class_name Stage
extends RefCounted
## Iluminação e câmera padrão das pranchas. Quem define luz é este arquivo, nunca uma prancha.

enum Mood { MANHA, MEIO_DIA, TARDE, ESTUDIO }

# Sol: inclinação, giro, cor e energia por situação. O material nunca muda, só a luz.
# ESTUDIO é a luz das fichas (personagens, objetos, natureza): quase frontal, sem sombra sobre o rosto.
const SUN := {
	Mood.ESTUDIO: {"pitch": -40.0, "yaw": -12.0, "color": Color("#FFF4E0"), "energy": 0.4},
	Mood.MANHA: {"pitch": -28.0, "yaw": -55.0, "color": Color("#FFD9A8"), "energy": 0.42},
	Mood.MEIO_DIA: {"pitch": -52.0, "yaw": -35.0, "color": Color("#FFF4E0"), "energy": 0.4},
	Mood.TARDE: {"pitch": -15.0, "yaw": 50.0, "color": Color("#FF9A55"), "energy": 0.5},
}
# Calibrado medindo pixels: com estes valores o chão bege (#E5DBC6) sai #E6DFC8 e a face de cima do marrom
# (#B1611F) sai #B86114, ou seja, a cor da paleta, sem estourar para branco.
const AMBIENT := Color("#B9CBE0") # preenchimento frio, igual em todas as pranchas
const AMBIENT_ENERGY := 0.28


## Cores do céu por situação (topo e horizonte), sempre misturas de cores da paleta.
static func sky_colors(mood: Mood) -> Array:
	var top := Palette.color("azul_ceu")
	var horizon := Palette.color("creme")
	match mood:
		Mood.MEIO_DIA:
			horizon = Palette.color("espuma")
		Mood.TARDE:
			top = Palette.color("azul_ceu").lerp(Palette.color("azul_flor"), 0.45)
			horizon = Palette.color("creme").lerp(Palette.color("laranja_fogo"), 0.55)
	return [top, horizon]


## Monta ambiente e sol em `parent`. `background`: nome da paleta (fundo liso) ou "" para céu em degradê.
static func light(parent: Node3D, mood: Mood = Mood.MEIO_DIA, background: String = "cinza_claro", fog: bool = false) -> void:
	var environment := Environment.new()
	var sky: Array = sky_colors(mood)
	if background.is_empty():
		var sky_material := ProceduralSkyMaterial.new()
		sky_material.sky_top_color = sky[0]
		sky_material.sky_horizon_color = sky[1]
		sky_material.ground_horizon_color = sky[1]
		sky_material.ground_bottom_color = Palette.color("bege")
		sky_material.sky_curve = 0.25 # o azul do céu aparece mais perto do horizonte
		sky_material.sun_angle_max = 0.0
		var sky_resource := Sky.new()
		sky_resource.sky_material = sky_material
		environment.background_mode = Environment.BG_SKY
		environment.sky = sky_resource
	else:
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Palette.color(background)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = AMBIENT
	environment.ambient_light_energy = AMBIENT_ENERGY
	if fog:
		environment.fog_enabled = true
		environment.fog_light_color = sky[1]
		environment.fog_density = 0.005
		environment.fog_sky_affect = 0.0 # a névoa suaviza o que está longe, mas não pinta o céu
	var world := WorldEnvironment.new()
	world.environment = environment
	parent.add_child(world)

	var sun := DirectionalLight3D.new()
	var spec: Dictionary = SUN[mood]
	sun.rotation_degrees = Vector3(spec.pitch, spec.yaw, 0.0)
	sun.light_color = spec.color
	sun.light_energy = spec.energy
	sun.shadow_enabled = true
	sun.shadow_blur = 1.6
	sun.directional_shadow_max_distance = 80.0
	parent.add_child(sun)


static func camera(parent: Node3D, pos: Vector3, look_at_point: Vector3, fov: float = 40.0) -> Camera3D:
	var cam := Camera3D.new()
	cam.fov = fov
	cam.far = 400.0
	parent.add_child(cam)
	cam.look_at_from_position(pos, look_at_point)
	cam.current = true
	return cam


static func ortho_camera(parent: Node3D, pos: Vector3, look_at_point: Vector3, size: float) -> Camera3D:
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = size
	cam.far = 400.0
	parent.add_child(cam)
	cam.look_at_from_position(pos, look_at_point)
	cam.current = true
	return cam
