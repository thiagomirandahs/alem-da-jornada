class_name Board06Effects
extends RefCounted
## Prancha 6: Visual Effects. Água, raios de luz, poeira, folhas, fogo e neblina com vaga-lumes, cada um sobre um fundo escuro da paleta.

const PITCH := 12.0
const CARD := Vector2(3.9, 3.0)
const COLUMNS := [-4.4, 0.0, 4.4]
const ROW_CENTER := [1.85, -1.75]


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")
	var samples := [
		[Fx.water(), "ÁGUA", 0.9],
		[Fx.light_shafts(), "RAIOS DE LUZ", 0.9],
		[Fx.dust(), "POEIRA", 0.9],
		[Fx.leaves(), "FOLHAS", 0.9],
		[Fx.fire(), "FOGO, FAÍSCAS E FUMAÇA", 0.9],
		[Fx.mist_fireflies(), "NEBLINA E VAGA-LUMES", 0.9],
	]
	for i in samples.size():
		var col := i % 3
		var row := i / 3
		var cx: float = COLUMNS[col]
		var cy: float = ROW_CENTER[row]
		# fundo escuro para as partículas claras aparecerem, e a base do efeito
# Fundo cinza médio da paleta (não preto): as partículas claras aparecem e a prancha continua clara como as outras.
		root.add_child(_backdrop(Vector3(CARD.x, CARD.y, 0.1), "cinza_grafite", Vector3(cx, cy, -1.4)))
		root.add_child(_backdrop(Vector3(CARD.x, 0.08, 2.6), "cinza_pedra", Vector3(cx, cy - CARD.y / 2.0 - 0.04, -0.2)))
		var effect: Node3D = samples[i][0]
		effect.position = Vector3(cx, cy - CARD.y / 2.0 + 0.1, 0)
		effect.scale = Vector3.ONE * samples[i][2]
		root.add_child(effect)
		root.add_child(ArtLabel.make(samples[i][1], Vector3(cx, cy + CARD.y / 2.0 - 0.28, -1.3), 0.0017, "creme"))

	var offset := Vector3(0, sin(deg_to_rad(PITCH)), cos(deg_to_rad(PITCH))) * 40.0
	var target := Vector3(0, 0.15, 0)
	Stage.ortho_camera(root, target + offset, target, 8.9)
	root.add_child(BoardFrame.build(6, "Visual Effects", "água · luz · poeira · folhas · fogo · neblina"))
	return root


## Fundo liso: não faz sombra nem recebe sombra dos vizinhos. Mesma cor da paleta, só sem o sombreado projetado.
static func _backdrop(size: Vector3, color_name: String, pos: Vector3) -> MeshInstance3D:
	var slab := LowPoly.box(size, color_name, pos)
	var flat := LowPoly.material(color_name).duplicate() as StandardMaterial3D
	flat.disable_receive_shadows = true
	slab.material_override = flat
	slab.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return slab
