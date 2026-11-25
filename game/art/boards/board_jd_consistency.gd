class_name BoardJdConsistency
extends RefCounted
## Pacote 16, verificação de consistência: o Desbravador (guia anterior), José e Daniel lado a lado na mesma escala e luz,
## e uma cena curta de cada universo com arquitetura, objetos e elenco. Serve para conferir se tudo parece o mesmo jogo.

const SPACING := 1.45
const LEFT := -4.35
const VIGNETTE_SCALE := 0.5


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")

	root.add_child(ArtLabel.make("ESCALA E ESTILO: EGITO · DESBRAVADOR (GUIA ANTERIOR) · BABILÔNIA", Vector3(-5.2, 2.62, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	var scout := Characters.build({"female": false, "skin": "pele_2", "hair": "cabelo_castanho", "hair_style": "franja"})
	var cast: Array = [
		["JOSÉ ADMINISTRADOR", Figures.build(Roles.jose_administrador()), -8.0],
		["TRABALHADOR", Figures.build(Roles.trabalhador()), 12.0],
		["MORADORA", Figures.build(Roles.morador()), -6.0],
		["DESBRAVADOR", scout, 0.0],
		["DANIEL ADULTO", Figures.build(Roles.daniel(1)), 8.0],
		["OFICIAL DA CORTE", Figures.build(Roles.oficial()), -10.0],
		["GUARDA CERIMONIAL", Figures.build(Roles.guarda_cerimonial()), 10.0],
	]
	for i in cast.size():
		var x := LEFT + i * SPACING
		var figure: Node3D = cast[i][1]
		figure.position = Vector3(x, 0.75, 0)
		figure.rotation_degrees.y = cast[i][2]
		figure.scale *= 0.92
		root.add_child(figure)
		root.add_child(LowPoly.prism(10, 0.62, 0.62, 0.05, "bege", Vector3(x, 0.7, 0)))
		root.add_child(ArtLabel.make(cast[i][0], Vector3(x, 0.45, 1.0), 0.0012, "cinza_grafite"))

	root.add_child(ArtLabel.make("ARQUITETURA, OBJETOS E ELENCO NA MESMA ESCALA", Vector3(-5.2, 0.12, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	_vignette(root, _egypt(), Vector3(-2.65, -2.25, 0), "EGITO: CASA DE ADOBE, CELEIRO, COLUNA E OBELISCO")
	_vignette(root, _babylon(), Vector3(2.7, -2.25, 0), "BABILÔNIA: MURALHA, TORRE E CASA DE PÁTIO")
	root.add_child(LowPoly.frustum(Vector2(0.03, 1.0), Vector2(0.03, 1.0), 2.2, "cinza_pedra", Vector3(0, -2.55, -0.5)))

	Stage.ortho_camera(root, Vector3(0, 0.2, 30), Vector3(0, 0.2, 0), 6.0)
	root.add_child(BoardFrame.build(16, "Consistência", "mesma escala, luz e paleta"))
	return root


static func _vignette(root: Node3D, content: Node3D, pos: Vector3, label: String) -> void:
	content.position = pos
	content.scale = Vector3.ONE * VIGNETTE_SCALE
	content.rotation_degrees.y = -12.0
	root.add_child(content)
	root.add_child(ArtLabel.make(label, Vector3(pos.x, pos.y - 0.32, 1.0), 0.0012, "cinza_grafite"))


static func _egypt() -> Node3D:
	var n := Node3D.new()
	n.add_child(LowPoly.frustum(Vector2(10.4, 7.0), Vector2(10.2, 6.8), 0.1, "bege", Vector3(0, -0.1, 1.0)))
	_put(n, Architecture.egypt_house(3.4, 3.0, 2.3), Vector3(-3.0, 0, -0.8), 20.0)
	_put(n, Architecture.granary(1.3, 2.4), Vector3(0.9, 0, -1.2))
	_put(n, Architecture.obelisk(3.2), Vector3(3.6, 0, -1.2))
	_put(n, Nature.palm(3.6), Vector3(4.8, 0, 1.6))
	_put(n, Architecture.egypt_column(3.0), Vector3(-1.3, 0, 1.5))
	_put(n, Figures.build(Roles.jose_administrador()), Vector3(0.5, 0, 2.7), -8.0)
	_put(n, Figures.build(Roles.trabalhador()), Vector3(2.0, 0, 2.2), -15.0)
	_put(n, Architecture.jar(0.5), Vector3(-2.3, 0, 2.2))
	_put(n, Architecture.grain_basket(), Vector3(3.0, 0, 2.8))
	return n


static func _babylon() -> Node3D:
	var n := Node3D.new()
	n.add_child(LowPoly.frustum(Vector2(10.4, 7.0), Vector2(10.2, 6.8), 0.1, "bege", Vector3(0, -0.1, 1.0)))
	_put(n, Architecture.babylon_tower(3.4, 1.9), Vector3(-3.5, 0, -1.2))
	_put(n, Architecture.city_wall(4.8, 2.4), Vector3(-1.0, 0, -1.2))
	_put(n, Architecture.babylon_house(2.9, 2.6, 2.0), Vector3(2.5, 0, 0.6), -15.0)
	_put(n, Architecture.banner_pole(2.6, "azul_lapis"), Vector3(-2.7, 0, 1.4))
	_put(n, Figures.build(Roles.daniel(1)), Vector3(-1.3, 0, 2.6), 8.0)
	_put(n, Figures.build(Roles.guarda_cerimonial()), Vector3(0.2, 0, 2.4), -10.0)
	_put(n, Architecture.clay_tablet(), Vector3(1.3, 0, 3.0))
	_put(n, Architecture.scroll(), Vector3(-2.2, 0, 3.2))
	return n


static func _put(parent: Node3D, node: Node3D, pos: Vector3, yaw: float = 0.0) -> void:
	node.position = pos
	node.rotation_degrees.y = yaw
	parent.add_child(node)
