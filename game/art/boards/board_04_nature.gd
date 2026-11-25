class_name Board04Nature
extends RefCounted
## Prancha 4: Nature Assets. Árvores, plantas, pedras, rio e animais, na mesma luz de estúdio e escala.

const PITCH := 18.0


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")

	# Linha de cima: árvores, montanha e plantas
	root.add_child(ArtLabel.make("VEGETAÇÃO E RELEVO", Vector3(-7.2, 3.9, 0), 0.0026, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	_place(root, Nature.pine(), Vector3(-5.6, 0.7, 0), 0.9, "PINHEIRO", 0.25)
	_place(root, Nature.broadleaf(), Vector3(-3.3, 0.7, 0), 0.9, "ÁRVORE DE COPA LARGA", 0.25)
	_place(root, Nature.palm(), Vector3(-1.0, 0.7, 0), 0.9, "PALMEIRA", 0.25)
	_place(root, Nature.mountain(7.0, 3.6), Vector3(2.4, 0.7, 0), 0.48, "MONTANHA", -0.2)
	_place(root, Nature.bush(), Vector3(5.0, 0.7, 0), 1.5, "ARBUSTO", 0.25)
	_place(root, Nature.flowers(), Vector3(6.5, 0.7, 0), 1.7, "FLORES", 0.25)

	# Linha de baixo: pedras, água e animais silvestres
	root.add_child(ArtLabel.make("PEDRAS, ÁGUA E ANIMAIS SILVESTRES", Vector3(-7.2, -0.55, 0), 0.0026, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	_place(root, Nature.rock(1.5), Vector3(-6.3, -2.55, 0), 1.0, "PEDRAS", -3.35)
	_place(root, Nature.river(3.6, 1.3), Vector3(-3.5, -2.55, 0), 1.0, "RIO", -3.35)
	_place(root, Nature.waterfall(), Vector3(-0.5, -2.55, 0), 1.0, "CACHOEIRA", -3.35)
	_place(root, Nature.capybara(), Vector3(2.2, -2.55, 0), 1.35, "CAPIVARA", -3.35)
	_place(root, Nature.macaw(), Vector3(4.2, -2.35, 0), 1.35, "ARARA", -3.35)
	_place(root, Nature.deer(), Vector3(6.2, -2.55, 0), 1.2, "VEADO", -3.35)

	var offset := Vector3(0, sin(deg_to_rad(PITCH)), cos(deg_to_rad(PITCH))) * 40.0
	var target := Vector3(0, 0.5, 0)
	Stage.ortho_camera(root, target + offset, target, 8.6)
	root.add_child(BoardFrame.build(4, "Nature Assets", "árvores · plantas · pedras · rio · animais"))
	return root


static func _place(root: Node3D, item: Node3D, pos: Vector3, item_scale: float, label: String, label_y: float) -> void:
	item.position = pos
	item.scale = Vector3.ONE * item_scale
	root.add_child(item)
	root.add_child(ArtLabel.make(label, Vector3(pos.x, label_y, 0), 0.0017, "cinza_grafite"))
