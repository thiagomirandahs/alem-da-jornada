class_name Props
extends RefCounted
## Objetos de exploração low-poly. Cada função devolve um Node3D com origem no chão (ou no centro, onde indicado),
## 1 unidade = 1 metro. Os personagens usam estes mesmos modelos (mochila, cantil, bota).


static func _add(parent: Node3D, child: Node3D) -> Node3D:
	parent.add_child(child)
	return child


## Mochila de exploração. Origem no centro do corpo; costas voltadas para -Z.
static func backpack() -> Node3D:
	var p := Node3D.new()
	p.name = "Mochila"
	_add(p, LowPoly.box(Vector3(0.4, 0.5, 0.2), "marrom"))
	_add(p, LowPoly.box(Vector3(0.42, 0.17, 0.22), "marrom_escuro", Vector3(0, 0.2, 0)))
	_add(p, LowPoly.box(Vector3(0.12, 0.14, 0.04), "vermelho", Vector3(0, -0.06, -0.11)))
	_add(p, LowPoly.prism(6, 0.09, 0.09, 0.46, "bege", Vector3(-0.23, 0.36, 0), Vector3(0, 0, -90))) # esteira
	for side in [-1.0, 1.0]:
		_add(p, LowPoly.box(Vector3(0.06, 0.2, 0.14), "marrom_escuro", Vector3(side * 0.23, -0.1, 0)))
	return p


## Cantil. Origem na base.
static func canteen() -> Node3D:
	var c := Node3D.new()
	c.name = "Cantil"
	_add(c, LowPoly.prism(6, 0.07, 0.07, 0.17, "verde_folha"))
	_add(c, LowPoly.box(Vector3(0.05, 0.04, 0.05), "marrom_escuro", Vector3(0, 0.19, 0)))
	return c


## Bota de trilha, pé voltado para +Z. Origem no chão, centro do pé.
static func boot() -> Node3D:
	var b := Node3D.new()
	b.name = "Bota"
	_add(b, LowPoly.box(Vector3(0.22, 0.14, 0.34), "marrom_escuro", Vector3(0, 0.11, 0.03)))
	_add(b, LowPoly.box(Vector3(0.23, 0.04, 0.36), "bege", Vector3(0, 0.02, 0.03)))
	_add(b, LowPoly.box(Vector3(0.18, 0.12, 0.2), "marrom", Vector3(0, 0.24, 0.0))) # cano; fica dentro da perna no personagem
	return b


## Lenço dos Desbravadores: ponta triangular amarela com acabamento vermelho e argola. Origem no centro, plano em XY.
static func neckerchief() -> Node3D:
	var s := Node3D.new()
	s.name = "Lenco"
	_add(s, LowPoly.prism(3, 0.5, 0.5, 0.05, "vermelho", Vector3.ZERO, Vector3(90, 0, 0), 30.0))
	_add(s, LowPoly.prism(3, 0.38, 0.38, 0.05, "amarelo_lenco", Vector3(0, 0.02, 0.04), Vector3(90, 0, 0), 30.0))
	_add(s, LowPoly.box(Vector3(0.14, 0.14, 0.07), "vermelho", Vector3(0, 0.3, 0.06)))
	return s


static func compass() -> Node3D:
	var c := Node3D.new()
	c.name = "Bussola"
	_add(c, LowPoly.prism(8, 0.13, 0.13, 0.05, "marrom_escuro"))
	_add(c, LowPoly.prism(8, 0.1, 0.1, 0.012, "bege", Vector3(0, 0.05, 0)))
	_add(c, LowPoly.box(Vector3(0.025, 0.014, 0.09), "vermelho", Vector3(0, 0.068, -0.045)))
	_add(c, LowPoly.box(Vector3(0.025, 0.014, 0.09), "cinza_pedra", Vector3(0, 0.068, 0.045)))
	_add(c, LowPoly.box(Vector3(0.05, 0.04, 0.05), "marrom_escuro", Vector3(0, 0.07, -0.15)))
	return c


## Mapa aberto em três dobras, com rio, rota e marca de destino. Origem no centro.
static func map() -> Node3D:
	var m := Node3D.new()
	m.name = "Mapa"
	for i in 3:
		var panel := Node3D.new()
		panel.position = Vector3((i - 1) * 0.24, 0.0, 0)
		panel.rotation_degrees.z = 7.0 if i % 2 == 0 else -7.0
		_add(panel, LowPoly.box(Vector3(0.24, 0.02, 0.52), "bege"))
		m.add_child(panel)
	_add(m, LowPoly.box(Vector3(0.62, 0.016, 0.05), "azul_agua", Vector3(0, 0.02, 0.08), Vector3(0, -18, 0)))
	_add(m, LowPoly.pyramid(4, 0.07, 0.08, "cinza_pedra", Vector3(-0.2, 0.02, -0.12)))
	_add(m, LowPoly.pyramid(5, 0.045, 0.07, "verde_floresta", Vector3(0.18, 0.02, -0.14)))
	for i in 4:
		_add(m, LowPoly.box(Vector3(0.05, 0.018, 0.02), "vermelho", Vector3(-0.22 + i * 0.12, 0.025, 0.18 - i * 0.07), Vector3(0, -15, 0)))
	_add(m, LowPoly.box(Vector3(0.1, 0.02, 0.022), "vermelho", Vector3(0.24, 0.03, -0.03), Vector3(0, 45, 0)))
	_add(m, LowPoly.box(Vector3(0.1, 0.02, 0.022), "vermelho", Vector3(0.24, 0.03, -0.03), Vector3(0, -45, 0)))
	return m


## Rolo de corda. Origem na base.
static func rope() -> Node3D:
	var r := Node3D.new()
	r.name = "Corda"
	_add(r, LowPoly.prism(8, 0.22, 0.22, 0.12, "bege"))
	for y in [0.03, 0.075]:
		_add(r, LowPoly.prism(8, 0.226, 0.226, 0.02, "marrom", Vector3(0, y, 0)))
	_add(r, LowPoly.prism(8, 0.09, 0.09, 0.125, "marrom_escuro"))
	_add(r, LowPoly.box(Vector3(0.05, 0.04, 0.34), "bege", Vector3(0.1, 0.02, 0.38), Vector3(0, 20, 0)))
	return r


## Lanterna. Origem na base.
static func lantern() -> Node3D:
	var l := Node3D.new()
	l.name = "Lanterna"
	_add(l, LowPoly.prism(6, 0.1, 0.1, 0.03, "cinza_grafite"))
	_add(l, LowPoly.prism(6, 0.085, 0.085, 0.2, "amarelo_brasa", Vector3(0, 0.03, 0)))
	_add(l, LowPoly.prism(6, 0.11, 0.05, 0.07, "cinza_grafite", Vector3(0, 0.23, 0)))
	_add(l, LowPoly.box(Vector3(0.02, 0.1, 0.02), "cinza_grafite", Vector3(0, 0.34, 0)))
	_add(l, LowPoly.box(Vector3(0.12, 0.02, 0.02), "cinza_grafite", Vector3(0, 0.4, 0)))
	return l


## Caixa de equipamentos. Origem na base.
static func crate() -> Node3D:
	var c := Node3D.new()
	c.name = "Caixa"
	_add(c, LowPoly.box(Vector3(0.7, 0.45, 0.5), "marrom", Vector3(0, 0.225, 0)))
	for y in [0.1, 0.35]:
		_add(c, LowPoly.box(Vector3(0.72, 0.05, 0.52), "marrom_escuro", Vector3(0, y, 0)))
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			_add(c, LowPoly.box(Vector3(0.06, 0.47, 0.06), "marrom_escuro", Vector3(sx * 0.33, 0.235, sz * 0.23)))
	_add(c, LowPoly.box(Vector3(0.16, 0.08, 0.02), "vermelho", Vector3(0, 0.25, 0.26)))
	return c


## Ponte de madeira ao longo de X. Origem no centro do vão, no nível do piso.
static func bridge(length: float = 4.0) -> Node3D:
	var b := Node3D.new()
	b.name = "Ponte"
	var count := int(length / 0.4)
	for i in count:
		var x := -length / 2.0 + 0.2 + i * (length / float(count))
		_add(b, LowPoly.box(Vector3(0.36, 0.06, 1.1), "marrom", Vector3(x, 0.0, 0)))
	for sz in [-1.0, 1.0]:
		_add(b, LowPoly.box(Vector3(length, 0.1, 0.08), "marrom_escuro", Vector3(0, -0.08, sz * 0.5)))
		_add(b, LowPoly.box(Vector3(length, 0.04, 0.04), "bege", Vector3(0, 0.78, sz * 0.55)))
		for sx in [-1.0, 1.0]:
			_add(b, LowPoly.box(Vector3(0.08, 0.9, 0.08), "marrom_escuro", Vector3(sx * (length / 2.0 - 0.05), 0.4, sz * 0.55)))
	return b


## Placa de orientação apontando para +X. Origem na base do poste.
static func sign_post(text: String = "TRILHA") -> Node3D:
	var s := Node3D.new()
	s.name = "Placa"
	_add(s, LowPoly.box(Vector3(0.1, 1.4, 0.1), "marrom_escuro", Vector3(0, 0.7, 0)))
	_add(s, LowPoly.box(Vector3(0.78, 0.28, 0.05), "bege", Vector3(-0.08, 1.2, 0.08)))
	_add(s, LowPoly.prism(3, 0.2, 0.2, 0.05, "bege", Vector3(0.31, 1.2, 0.08), Vector3(90, 0, 0), 0.0))
	_add(s, LowPoly.box(Vector3(0.82, 0.03, 0.055), "vermelho", Vector3(-0.08, 1.07, 0.08)))
	_add(s, ArtLabel.make(text, Vector3(-0.1, 1.2, 0.112), 0.0011, "marrom_escuro"))
	return s


## Barraca de acampamento (prisma triangular, ~1,25 m de altura). Frente (porta) voltada para +Z. Origem no centro do chão.
static func tent(shell_color: String = "bege") -> Node3D:
	var t := Node3D.new()
	t.name = "Barraca"
	var shell := Node3D.new()
	shell.position = Vector3(0, 0.415, -1.2)
	shell.scale = Vector3(1.0, 0.72, 1.0)
	_add(shell, LowPoly.prism(3, 1.155, 1.155, 2.4, shell_color, Vector3.ZERO, Vector3(90, 0, 0), -30.0))
	t.add_child(shell)
	_add(t, LowPoly.prism(3, 0.5, 0.5, 0.05, "marrom_escuro", Vector3(0, 0.46, 1.205), Vector3(90, 0, 0), -30.0))
	_add(t, LowPoly.box(Vector3(0.09, 0.07, 2.46), "vermelho", Vector3(0, 1.25, 0)))
	_add(t, LowPoly.box(Vector3(2.2, 0.04, 2.6), "verde_floresta", Vector3(0, 0.02, 0))) # lona do chão
	for sx in [-1.0, 1.0]:
		_add(t, LowPoly.box(Vector3(0.05, 0.28, 0.05), "marrom_escuro", Vector3(sx * 1.25, 0.1, 1.45), Vector3(0, 0, sx * -25)))
		_add(t, LowPoly.box(Vector3(0.02, 0.02, 0.62), "bege", Vector3(sx * 1.05, 0.55, 1.2), Vector3(-45, sx * 20, 0)))
	return t


## Fogueira: círculo de pedras, lenha e chamas facetadas. Origem no chão, centro.
static func campfire() -> Node3D:
	var f := Node3D.new()
	f.name = "Fogueira"
	for i in 8:
		var a := TAU * i / 8.0
		_add(f, LowPoly.prism(5, 0.16, 0.12, 0.16, "cinza_pedra", Vector3(cos(a) * 0.5, 0, sin(a) * 0.5), Vector3(0, i * 37.0, 0)))
	for i in 3:
		_add(f, LowPoly.box(Vector3(0.7, 0.1, 0.1), "marrom_escuro", Vector3(0, 0.1, 0), Vector3(0, i * 60.0, 12 if i % 2 == 0 else -12)))
	_add(f, LowPoly.pyramid(5, 0.24, 0.7, "laranja_fogo", Vector3(0, 0.1, 0)))
	_add(f, LowPoly.pyramid(4, 0.15, 0.55, "amarelo_brasa", Vector3(0.09, 0.1, 0.05), Vector3(0, 20, 8)))
	_add(f, LowPoly.pyramid(4, 0.13, 0.45, "amarelo_brasa", Vector3(-0.1, 0.1, -0.04), Vector3(0, 40, -8)))
	return f
