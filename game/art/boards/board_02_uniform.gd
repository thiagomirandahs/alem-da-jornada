class_name Board02Uniform
extends RefCounted
## Prancha 2: Uniform Design. Uniforme completo, detalhes (lenço, mochila, bota, cantil, bússola) e variações de aparência.

const COLUMNS := [-0.45, 0.6, 1.65, 2.7, 3.75]
const VARIANTS := [
	{"female": false, "skin": "pele_1", "hair": "cabelo_loiro", "hair_style": "franja"},
	{"female": true, "skin": "pele_5", "hair": "cabelo_preto", "hair_style": "volume"},
	{"female": false, "skin": "pele_4", "hair": "cabelo_preto", "hair_style": "curto"},
	{"female": true, "skin": "pele_3", "hair": "cabelo_ruivo", "hair_style": "trancas"},
	{"female": false, "skin": "pele_2", "hair": "cabelo_castanho", "hair_style": "volume"},
]


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")

	# Uniforme completo
	var hero := Characters.build({"skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto", "female": false})
	hero.position = Vector3(-2.85, -1.65, 0)
	hero.scale = Vector3.ONE * 1.85
	hero.rotation_degrees.y = 28.0
	root.add_child(hero)
	root.add_child(LowPoly.prism(10, 1.4, 1.4, 0.1, "bege", Vector3(-2.85, -1.75, 0)))
	root.add_child(ArtLabel.make("UNIFORME COMPLETO", Vector3(-2.85, -2.05, 1.0), 0.0022, "cinza_grafite"))

	# Detalhes
	root.add_child(ArtLabel.make("DETALHES DO UNIFORME", Vector3(-1.0, 2.05, 0), 0.0024, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	_place(root, Props.neckerchief(), Vector3(COLUMNS[0], 1.35, 0), 1.0, Vector3(0, 0, 0))
	_place(root, Props.backpack(), Vector3(COLUMNS[1], 1.3, 0), 1.35, Vector3(0, 155, 0))
	_place(root, Props.boot(), Vector3(COLUMNS[2], 0.95, 0), 2.1, Vector3(0, 40, 0))
	_place(root, Props.canteen(), Vector3(COLUMNS[3], 0.9, 0), 3.2, Vector3(0, 25, 0))
	_place(root, Props.compass(), Vector3(COLUMNS[4], 1.35, 0), 3.4, Vector3(60, 0, 0))
	var names := ["LENÇO", "MOCHILA", "BOTA", "CANTIL", "BÚSSOLA"]
	for i in COLUMNS.size():
		root.add_child(ArtLabel.make(names[i], Vector3(COLUMNS[i], 0.5, 1.0), 0.0016, "cinza_grafite"))

	# Variações de aparência: o uniforme não muda
	root.add_child(ArtLabel.make("VARIAÇÕES: PELE, CABELO E PENTEADO", Vector3(-1.0, 0.0, 0), 0.0024, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	for i in VARIANTS.size():
		var figure := Characters.build(VARIANTS[i])
		figure.position = Vector3(COLUMNS[i], -1.95, 0)
		figure.scale = Vector3.ONE * 0.92
		root.add_child(figure)
		root.add_child(LowPoly.prism(10, 0.55, 0.55, 0.05, "bege", Vector3(COLUMNS[i], -1.99, 0)))

	Stage.ortho_camera(root, Vector3(0, 0.2, 30), Vector3(0, 0.2, 0), 5.0)
	root.add_child(BoardFrame.build(2, "Uniform Design", "lenço amarelo e vermelho · mochila · botas"))
	return root


static func _place(root: Node3D, item: Node3D, pos: Vector3, item_scale: float, rot_deg: Vector3) -> void:
	item.position = pos
	item.scale = Vector3.ONE * item_scale
	item.rotation_degrees = rot_deg
	root.add_child(item)
