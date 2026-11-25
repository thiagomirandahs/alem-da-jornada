class_name Board05Props
extends RefCounted
## Prancha 5: Props Design. Objetos ampliados para leitura e, embaixo, em escala real ao lado de um Desbravador.

const PITCH := 18.0
const COLUMNS := [-6.0, -3.6, -1.2, 1.2, 3.6, 6.0]
const ROW_BASE := [2.5, 0.1]
const STRIP_BASE := -2.75


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")

	# Objetos ampliados: [modelo, escala, giro, rótulo, ajuste de altura para os de origem no centro]
	var items := [
		[Props.tent(), 0.62, Vector3(0, 35, 0), "BARRACA", 0.0],
		[Props.bridge(4.0), 0.42, Vector3(0, 30, 0), "PONTE", 0.0],
		[Props.sign_post("TRILHA"), 0.95, Vector3(0, -25, 0), "PLACA", 0.0],
		[Props.campfire(), 1.1, Vector3(0, 0, 0), "FOGUEIRA", 0.0],
		[Props.crate(), 1.9, Vector3(0, 30, 0), "CAIXA", 0.0],
		[Props.lantern(), 2.8, Vector3(0, 0, 0), "LANTERNA", 0.0],
		[Props.backpack(), 1.7, Vector3(0, 150, 0), "MOCHILA", 0.4],
		[Props.canteen(), 4.2, Vector3(0, 20, 0), "CANTIL", 0.0],
		[Props.rope(), 3.3, Vector3(0, 0, 0), "CORDA", 0.0],
		[Props.map(), 2.6, Vector3(35, 0, 0), "MAPA", 0.45],
		[Props.compass(), 4.4, Vector3(55, 0, 0), "BÚSSOLA", 0.45],
	]
	for i in items.size():
		var col: int = i % COLUMNS.size()
		var row: int = i / COLUMNS.size()
		var item: Node3D = items[i][0]
		item.position = Vector3(COLUMNS[col], ROW_BASE[row] + items[i][4], 0)
		item.scale = Vector3.ONE * items[i][1]
		item.rotation_degrees = items[i][2]
		root.add_child(item)
		root.add_child(LowPoly.prism(10, 0.8, 0.8, 0.04, "bege", Vector3(COLUMNS[col], ROW_BASE[row] - 0.05, 0)))
		root.add_child(ArtLabel.make(items[i][3], Vector3(COLUMNS[col], ROW_BASE[row] - 0.6, 0), 0.0017, "cinza_grafite"))

	# Escala real: o Desbravador ao lado dos objetos em tamanho natural
	root.add_child(ArtLabel.make("ESCALA REAL: O DESBRAVADOR MEDE 1,5 M", Vector3(-7.2, -0.95, 0), 0.0026, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	root.add_child(LowPoly.box(Vector3(14.6, 0.05, 1.8), "bege", Vector3(0, STRIP_BASE - 0.03, 0)))
	var scout := Characters.build({"skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto"})
	scout.position = Vector3(-5.6, STRIP_BASE, 0.3)
	root.add_child(scout)
	var strip := [
		[Props.backpack(), Vector3(-4.2, STRIP_BASE + 0.25, 0.3), 30.0],
		[Props.tent(), Vector3(-1.9, STRIP_BASE, 0), 0.0],
		[Props.sign_post("TRILHA"), Vector3(0.2, STRIP_BASE, 0.2), 0.0],
		[Props.crate(), Vector3(1.3, STRIP_BASE, 0.3), 20.0],
		[Props.rope(), Vector3(2.4, STRIP_BASE, 0.4), 0.0],
		[Props.campfire(), Vector3(3.6, STRIP_BASE, 0.2), 0.0],
		[Props.bridge(2.4), Vector3(6.0, STRIP_BASE, 0.3), 0.0],
	]
	for s in strip:
		var obj: Node3D = s[0]
		obj.position = s[1]
		obj.rotation_degrees.y = s[2]
		root.add_child(obj)
	var lantern := Props.lantern()
	lantern.position = Vector3(1.3, STRIP_BASE + 0.45, 0.3)
	root.add_child(lantern)

	var offset := Vector3(0, sin(deg_to_rad(PITCH)), cos(deg_to_rad(PITCH))) * 40.0
	var target := Vector3(0, 0.4, 0)
	Stage.ortho_camera(root, target + offset, target, 8.6)
	root.add_child(BoardFrame.build(5, "Props Design", "objetos e equipamentos de exploração"))
	return root
