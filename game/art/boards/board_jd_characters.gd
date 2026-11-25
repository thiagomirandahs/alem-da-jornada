class_name BoardJdCharacters
extends RefCounted
## Pacotes 01 (personagens de José) e 06 (personagens de Daniel): protagonista em vistas frontal, lateral e traseira,
## elenco de apoio e estudos de expressão, na luz de estúdio do kit.

const SPACING := 1.45
const LEFT := -4.35


static func jose() -> Node3D:
	var root := _stage()
	var front_views := [["FRENTE", 0.0], ["LADO", 90.0], ["COSTAS", 180.0]]
	var x := LEFT
	for phase in [Roles.jose_jovem(), Roles.jose_administrador()]:
		for view in front_views:
			_figure(root, phase, Vector3(x, 0.75, 0), view[1], "%s\n%s" % [phase.name.to_upper(), view[0]] if view[0] == "FRENTE" else view[0])
			x += SPACING
	_figure(root, Roles.trabalhador(), Vector3(x, 0.75, 0), 20.0, "TRABALHADOR")
	root.add_child(ArtLabel.make("JOSÉ EM DUAS FASES (JOVEM HEBREU E ADMINISTRADOR) E UM TRABALHADOR", Vector3(-5.2, 2.62, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))

	root.add_child(ArtLabel.make("ELENCO DE APOIO E ESTUDOS DE EXPRESSÃO", Vector3(-5.2, 0.12, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	var cast := [Roles.guardiao_celeiro(), Roles.comerciante(), Roles.viajante(), Roles.morador()]
	for i in cast.size():
		_figure(root, cast[i], Vector3(LEFT + i * SPACING, -1.95, 0), 15.0 - i * 10.0, cast[i].name.to_upper())
	_expressions(root, Roles.jose_administrador(), Vector3(1.75, -1.95, 0))
	_finish(root, 1, "José: personagens", "pacote 01 · Egito")
	return root


static func daniel() -> Node3D:
	var root := _stage()
	var x := LEFT
	for view in [["FRENTE", 0.0], ["LADO", 90.0], ["COSTAS", 180.0]]:
		_figure(root, Roles.daniel(1), Vector3(x, 0.75, 0), view[1], "DANIEL ADULTO\nFRENTE" if view[0] == "FRENTE" else view[0])
		x += SPACING
	_figure(root, Roles.daniel(0), Vector3(x, 0.75, 0), 20.0, "DANIEL JOVEM")
	x += SPACING
	_figure(root, Roles.daniel(2), Vector3(x, 0.75, 0), -20.0, "DANIEL IDOSO")
	x += SPACING
	for i in 2:
		_figure(root, Roles.companheiro(i), Vector3(x, 0.75, 0), 25.0 - i * 40.0, "COMPANHEIRO")
		x += SPACING
	root.add_child(ArtLabel.make("DANIEL EM TRÊS FASES E SEUS COMPANHEIROS", Vector3(-5.2, 2.62, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))

	root.add_child(ArtLabel.make("CORTE, ESCRIBAS, SÁBIOS E SERVIDORES · ESTUDOS DE EXPRESSÃO", Vector3(-5.2, 0.12, 0), 0.0019, "marrom_escuro", HORIZONTAL_ALIGNMENT_LEFT))
	var cast := [Roles.oficial(), Roles.escriba(), Roles.sabio(), Roles.guarda_cerimonial(), Roles.servidor()]
	for i in cast.size():
		_figure(root, cast[i], Vector3(LEFT + i * SPACING, -1.95, 0), 12.0 - i * 8.0, cast[i].name.to_upper())
	_expressions(root, Roles.daniel(1), Vector3(2.35, -1.95, 0))
	_finish(root, 6, "Daniel: personagens", "pacote 06 · Babilônia")
	return root


static func _stage() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.ESTUDIO, "cinza_claro")
	return root


static func _figure(root: Node3D, role: Dictionary, pos: Vector3, yaw: float, label: String) -> void:
	var figure := Figures.build(role)
	figure.position = pos
	figure.rotation_degrees.y = yaw
	figure.scale *= 0.92
	root.add_child(figure)
	root.add_child(LowPoly.prism(10, 0.62, 0.62, 0.05, "bege", Vector3(pos.x, pos.y - 0.05, 0)))
	root.add_child(ArtLabel.make(label, Vector3(pos.x, pos.y - 0.3, 1.0), 0.0013, "cinza_grafite"))


## Quatro cabeças com expressões diferentes (sereno, sorriso, determinado, surpreso).
static func _expressions(root: Node3D, role: Dictionary, origin: Vector3, spacing: float = 0.82) -> void:
	var moods := ["sereno", "sorriso", "determinado", "surpreso"]
	for i in moods.size():
		var o := role.duplicate()
		o["mood"] = moods[i]
		var head := Figures.build_head(o)
		head.position = origin + Vector3(i * spacing, 0.35, 0)
		head.scale = Vector3.ONE * 1.5
		root.add_child(head)
		root.add_child(ArtLabel.make(moods[i].to_upper(), origin + Vector3(i * spacing, -0.1, 1.0), 0.0012, "cinza_grafite"))


static func _finish(root: Node3D, number: int, title: String, subtitle: String) -> void:
	Stage.ortho_camera(root, Vector3(0, 0.2, 30), Vector3(0, 0.2, 0), 6.0)
	root.add_child(BoardFrame.build(number, title, subtitle))
