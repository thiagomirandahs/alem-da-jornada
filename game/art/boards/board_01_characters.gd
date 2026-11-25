class_name Board01Characters
extends RefCounted
## Prancha 1: Character Design. Masculino e feminino, de frente, de lado e de costas, na mesma luz e escala.

const COLUMN_SPACING := 2.5
const COLUMN_OFFSET := 0.9
const VIEWS := [["FRENTE", 0.0], ["LADO", 90.0], ["COSTAS", 180.0]]
const ROWS := [
	["MASCULINO", {"skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto", "female": false}, 0.6],
	["FEMININO", {"skin": "pele_2", "hair": "cabelo_preto", "hair_style": "rabo", "female": true}, -1.7],
]


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")
	for row in ROWS:
		var base_y: float = row[2]
		for i in VIEWS.size():
			var x := (i - 1) * COLUMN_SPACING + COLUMN_OFFSET
			var figure := Characters.build(row[1])
			figure.position = Vector3(x, base_y, 0)
			figure.rotation_degrees.y = VIEWS[i][1]
			root.add_child(figure)
			root.add_child(LowPoly.prism(10, 0.85, 0.85, 0.06, "bege", Vector3(x, base_y - 0.06, 0)))
			root.add_child(ArtLabel.make(VIEWS[i][0], Vector3(x, base_y - 0.3, 1.0), 0.0026, "cinza_grafite"))
		root.add_child(ArtLabel.make(row[0], Vector3(-4.35, base_y + 0.95, 0), 0.0024, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
		var sheet := Characters.build(row[1])
		var specs := ("%.2f m · cabeça %.2f m\n%d triângulos" % [Characters.HEIGHT, 0.44, LowPoly.triangles(sheet)]).replace(".", ",")
		sheet.free()
		root.add_child(ArtLabel.make(specs, Vector3(-4.35, base_y + 0.6, 0), 0.0015, "cinza_grafite", HORIZONTAL_ALIGNMENT_LEFT))
	Stage.ortho_camera(root, Vector3(0, 0.2, 30), Vector3(0, 0.2, 0), 5.0)
	root.add_child(BoardFrame.build(1, "Character Design", "≈ 3,3 cabeças · rosto amigável · uniforme"))
	return root
