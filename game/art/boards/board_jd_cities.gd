class_name BoardJdCities
extends RefCounted
## Pacotes 03 (cidade do Egito, universo de José) e 08 (cidade da Babilônia, universo de Daniel): uma cena por universo,
## com planos de profundidade, arquitetura, vegetação, água e o elenco histórico em escala real. Luz só do Stage.


static func egypt() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.MEIO_DIA, "", true)
	_add(root, LowPoly.box(Vector3(280, 0.5, 280), "bege", Vector3(0, -0.25, -80)))
	_add(root, LowPoly.prism(10, 6.4, 6.4, 0.05, "creme", Vector3(1, 0, 1.5)))

	# Nilo ao fundo, com faixa irrigada, canal e palmeiral
	var nile := Nature.river(280.0, 9.0)
	nile.position = Vector3(0, 0, -26)
	_add(root, nile)
	_add(root, LowPoly.box(Vector3(280, 0.08, 5.0), "verde_folha", Vector3(0, 0.03, -19.2)))
	var canal := Nature.river(22.0, 1.4)
	canal.position = Vector3(-17.5, 0, -9)
	canal.rotation_degrees.y = 90.0
	_add(root, canal)
	for p in [Vector3(-14.5, 0, 1.8), Vector3(-14.8, 0, 5.4), Vector3(-20.5, 0, 2.0), Vector3(-21.0, 0, 5.6)]:
		_place(root, Architecture.wheat_patch(4, 6), p, 5.0)

	# Palácio ao centro, com obeliscos na frente
	_place(root, Architecture.egypt_palace(9.0), Vector3(1, 0, -9.5))
	_place(root, Architecture.obelisk(4.4), Vector3(-3.6, 0, -4.4))
	_place(root, Architecture.obelisk(4.4), Vector3(5.6, 0, -4.4))

	# Casas à esquerda e celeiros à direita
	for spec in [[-9.5, -2.6, 18.0, 1.05], [-6.4, -7.0, -8.0, 0.95], [-12.5, -8.5, 6.0, 1.15], [13.5, -8.5, -12.0, 1.0]]:
		_place(root, Architecture.egypt_house(3.4 * spec[3], 3.0 * spec[3], 2.3 * spec[3]), Vector3(spec[0], 0, spec[1]), spec[2])
	for spec in [[9.0, -3.8, 0.0, 1.0], [12.4, -2.0, 0.0, 1.2], [10.6, -7.0, 0.0, 1.1]]:
		_place(root, Architecture.granary(1.5 * spec[3], 2.6 * spec[3]), Vector3(spec[0], 0, spec[1]), spec[2])
	_place(root, Architecture.market_stall(), Vector3(-4.2, 0, 3.4), 8.0)

	# Palmeiras
	for spec in [[-6.0, -12.0, 4.2], [9.0, -12.5, 3.8], [-15.0, -4.0, 4.0], [15.5, 0.5, 3.6], [3.0, -14.5, 4.4], [-11.0, 3.5, 3.4]]:
		_place(root, Nature.palm(spec[2]), Vector3(spec[0], 0, spec[1]))
	for i in 12: # palmeiral do outro lado do rio
		_place(root, Nature.palm(3.6 + 0.2 * (i % 3)), Vector3(-34.0 + i * 6.0, 0, -35.5 + 1.5 * (i % 2)))

	# Pirâmides ao longe
	for spec in [[-30.0, -95.0, 28.0], [8.0, -115.0, 38.0], [48.0, -100.0, 22.0]]:
		_place(root, Architecture.far_pyramid(spec[2]), Vector3(spec[0], 0, spec[1]))

	# Elenco em escala real na praça
	for spec in [
		[Roles.jose_administrador(), Vector3(1.6, 0, 3.4), -8.0],
		[Roles.trabalhador(), Vector3(4.2, 0, 2.2), 20.0],
		[Roles.morador(), Vector3(-1.4, 0, 2.2), 14.0],
		[Roles.comerciante(), Vector3(-3.3, 0, 2.2), 170.0],
		[Roles.guardiao_celeiro(), Vector3(7.2, 0, -0.2), -25.0],
		[Roles.viajante(), Vector3(10.0, 0, 2.6), -40.0],
	]:
		_place(root, Figures.build(spec[0]), spec[1], spec[2])
	_place(root, Architecture.grain_basket(), Vector3(6.0, 0, 1.3))
	_place(root, Architecture.jar(0.55), Vector3(-5.9, 0, 2.2))
	for i in 5:
		_place(root, Nature.rock(0.5 + 0.15 * (i % 3)), Vector3(-9.0 + i * 4.6, 0, 6.5 + 0.7 * (i % 2)), i * 40.0)

	Stage.camera(root, Vector3(0.0, 3.4, 11.5), Vector3(1.0, 2.4, -6.0), 50.0)
	root.add_child(BoardFrame.build(3, "Cidade do Egito", "universo de José · pacote 03"))
	return root


static func babylon() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.MANHA, "", false)
	_add(root, LowPoly.box(Vector3(280, 0.5, 280), "bege", Vector3(0, -0.25, -80)))
	# Via processional até o portão
	_add(root, LowPoly.frustum(Vector2(3.6, 80), Vector2(3.5, 79), 0.06, "creme", Vector3(0, 0, -20)))
	for side in [-1.0, 1.0]:
		_add(root, LowPoly.frustum(Vector2(0.18, 80), Vector2(0.16, 79), 0.09, "dourado_antigo", Vector3(side * 1.9, 0, -20)))

	# Portão e muralha com torres
	_place(root, Architecture.babylon_gate(7.0), Vector3(0, 0, -14), 0.0, 1.25)
	for side in [-1.0, 1.0]:
		_place(root, Architecture.city_wall(14.0, 3.4), Vector3(side * 10.4, 0, -14))
		_place(root, Architecture.babylon_tower(5.4, 2.4), Vector3(side * 17.6, 0, -14))
		_place(root, Architecture.babylon_tower(5.4, 2.4), Vector3(side * 17.6, 0, -26), 0.0)

	# Dentro dos muros: zigurate, jardim em terraços e casas
	_place(root, Architecture.ziggurat(3), Vector3(21, 0, -34), 0.0, 1.3)
	_place(root, Architecture.garden_terrace(3), Vector3(-23, 0, -34), 0.0, 1.4)
	for spec in [[-5.0, -22.0, 10.0], [14.0, -21.0, -15.0]]:
		_place(root, Architecture.babylon_house(), Vector3(spec[0], 0, spec[1]), spec[2])

	# Casas na frente, ladeando a via, e canal com palmeiras
	for spec in [[-9.5, 1.5, 22.0, 1.0], [-11.0, -5.5, 6.0, 1.1], [9.5, 0.5, -20.0, 1.0], [10.5, -6.0, -6.0, 1.1]]:
		_place(root, Architecture.babylon_house(4.0 * spec[3], 3.6 * spec[3], 2.6 * spec[3]), Vector3(spec[0], 0, spec[1]), spec[2])
	var canal := Nature.river(44.0, 3.2)
	canal.position = Vector3(17.5, 0, -6)
	canal.rotation_degrees.y = 90.0
	_add(root, canal)
	for spec in [[14.0, 2.0, 3.8], [14.4, -6.5, 4.2], [21.0, -3.0, 3.6], [-15.0, -2.0, 4.0]]:
		_place(root, Nature.palm(spec[2]), Vector3(spec[0], 0, spec[1]))
	for i in 3:
		for side in [-1.0, 1.0]:
			_place(root, Architecture.banner_pole(3.6, "azul_lapis" if (i + int(side)) % 2 == 0 else "dourado_antigo"), Vector3(side * 2.3, 0, 3.0 - i * 4.2))

	# Elenco em escala real na via
	for spec in [
		[Roles.daniel(1), Vector3(0.4, 0, 4.6), 8.0],
		[Roles.oficial(), Vector3(-2.6, 0, 2.6), 22.0],
		[Roles.escriba(), Vector3(3.2, 0, 2.8), -18.0],
		[Roles.sabio(), Vector3(-5.2, 0, 4.2), 30.0],
		[Roles.servidor(), Vector3(5.8, 0, 1.0), -32.0],
		[Roles.guarda_cerimonial(), Vector3(-2.0, 0, -8.4), 0.0],
		[Roles.guarda_cerimonial(), Vector3(2.0, 0, -8.4), 0.0],
	]:
		_place(root, Figures.build(spec[0]), spec[1], spec[2])
	for i in 4:
		_place(root, Nature.rock(0.5 + 0.15 * (i % 3)), Vector3(-9.0 + i * 5.2, 0, 7.0 + 0.6 * (i % 2)), i * 55.0)

	Stage.camera(root, Vector3(0.0, 3.4, 12.5), Vector3(0.0, 3.4, -10.0), 50.0)
	root.add_child(BoardFrame.build(8, "Cidade da Babilônia", "universo de Daniel · pacote 08"))
	return root


static func _add(parent: Node3D, child: Node3D) -> void:
	parent.add_child(child)


static func _place(parent: Node3D, node: Node3D, pos: Vector3, yaw: float = 0.0, scale: float = 1.0) -> void:
	node.position = pos
	node.rotation_degrees.y = yaw
	node.scale = Vector3.ONE * scale
	parent.add_child(node)
