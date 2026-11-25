class_name Nature
extends RefCounted
## Natureza low-poly: árvores, plantas, pedras, montanhas, rio e animais. Origem no chão, 1 unidade = 1 metro.
## Mesma linguagem dos personagens: caixas e prismas facetados, cores só da Palette.


static func _add(parent: Node3D, child: Node3D) -> Node3D:
	parent.add_child(child)
	return child


## Pinheiro: tronco e três andares de pirâmide.
static func pine(height: float = 3.2) -> Node3D:
	var t := Node3D.new()
	t.name = "Pinheiro"
	var k := height / 3.2
	_add(t, LowPoly.prism(5, 0.13 * k, 0.1 * k, 0.9 * k, "marrom_escuro"))
	_add(t, LowPoly.pyramid(6, 1.0 * k, 1.2 * k, "verde_floresta", Vector3(0, 0.55 * k, 0)))
	_add(t, LowPoly.pyramid(6, 0.78 * k, 1.1 * k, "verde_floresta", Vector3(0, 1.3 * k, 0), Vector3(0, 30, 0)))
	_add(t, LowPoly.pyramid(6, 0.52 * k, 1.0 * k, "verde_folha", Vector3(0, 2.0 * k, 0)))
	return t


## Árvore de copa larga: tronco e blocos de folhagem.
static func broadleaf(height: float = 3.0) -> Node3D:
	var t := Node3D.new()
	t.name = "Arvore"
	var k := height / 3.0
	_add(t, LowPoly.prism(5, 0.17 * k, 0.13 * k, 1.5 * k, "marrom_escuro"))
	_add(t, LowPoly.box(Vector3(1.5, 1.0, 1.5) * k, "verde_folha", Vector3(0, 1.95 * k, 0), Vector3(0, 18, 0)))
	_add(t, LowPoly.box(Vector3(1.0, 0.8, 1.0) * k, "verde_claro", Vector3(0.35, 2.6 * k, 0.2 * k), Vector3(0, -12, 0)))
	_add(t, LowPoly.box(Vector3(0.9, 0.7, 0.9) * k, "verde_floresta", Vector3(-0.55, 1.65 * k, 0.4 * k), Vector3(0, 35, 0)))
	return t


## Palmeira: tronco levemente curvo e folhas em leque.
static func palm(height: float = 3.6) -> Node3D:
	var t := Node3D.new()
	t.name = "Palmeira"
	var k := height / 3.6
	for i in 4:
		_add(t, LowPoly.box(Vector3(0.24 - i * 0.025, 0.9, 0.24 - i * 0.025) * Vector3(k, k, k), "marrom", Vector3(i * 0.07 * k, (0.45 + i * 0.85) * k, 0)))
	var crown := Vector3(0.28 * k, 3.45 * k, 0)
	for i in 7:
		_add(t, LowPoly.box(Vector3(1.35, 0.05, 0.4) * k, "verde_folha" if i % 2 == 0 else "verde_floresta", crown + Vector3(0, 0, 0), Vector3(0, i * 51.0, -22)))
		t.get_child(t.get_child_count() - 1).position = crown + Vector3(cos(deg_to_rad(i * 51.0)) * 0.55 * k, 0, -sin(deg_to_rad(i * 51.0)) * 0.55 * k)
	_add(t, LowPoly.box(Vector3(0.16, 0.16, 0.16) * k, "marrom_escuro", crown + Vector3(0.08, -0.12, 0.1)))
	_add(t, LowPoly.box(Vector3(0.16, 0.16, 0.16) * k, "marrom_escuro", crown + Vector3(-0.1, -0.12, -0.08)))
	return t


static func bush() -> Node3D:
	var b := Node3D.new()
	b.name = "Arbusto"
	_add(b, LowPoly.prism(6, 0.5, 0.34, 0.5, "verde_folha"))
	_add(b, LowPoly.prism(5, 0.34, 0.2, 0.42, "verde_claro", Vector3(0.28, 0, 0.12), Vector3(0, 20, 0)))
	_add(b, LowPoly.prism(5, 0.3, 0.18, 0.36, "verde_floresta", Vector3(-0.3, 0, -0.1), Vector3(0, 50, 0)))
	return b


## Canteiro de flores: hastes e botões em três cores da paleta.
static func flowers() -> Node3D:
	var f := Node3D.new()
	f.name = "Flores"
	var colors := ["rosa_flor", "azul_flor", "amarelo_lenco", "rosa_flor", "amarelo_lenco", "azul_flor"]
	for i in colors.size():
		var a := TAU * i / colors.size() + 0.4
		var pos := Vector3(cos(a) * 0.28, 0, sin(a) * 0.28)
		var height := 0.3 + 0.07 * (i % 3)
		_add(f, LowPoly.box(Vector3(0.025, height, 0.025), "verde_folha", pos + Vector3(0, height / 2.0, 0)))
		_add(f, LowPoly.pyramid(4, 0.07, 0.09, colors[i], pos + Vector3(0, height, 0), Vector3(0, i * 20.0, 0)))
	return f


static func grass() -> Node3D:
	var g := Node3D.new()
	g.name = "Capim"
	for i in 5:
		var a := TAU * i / 5.0
		_add(g, LowPoly.pyramid(3, 0.05, 0.3 + 0.05 * (i % 3), "verde_claro" if i % 2 == 0 else "verde_folha", Vector3(cos(a) * 0.08, 0, sin(a) * 0.08), Vector3(8 * cos(a), 0, 8 * sin(a))))
	return g


## Pedra: prismas irregulares empilhados.
static func rock(size: float = 1.0) -> Node3D:
	var r := Node3D.new()
	r.name = "Pedra"
	_add(r, LowPoly.prism(5, 0.6 * size, 0.42 * size, 0.55 * size, "cinza_pedra", Vector3.ZERO, Vector3(0, 12, 0)))
	_add(r, LowPoly.prism(4, 0.38 * size, 0.24 * size, 0.42 * size, "cinza_grafite", Vector3(0.45 * size, 0, 0.2 * size), Vector3(0, 40, 0)))
	_add(r, LowPoly.prism(5, 0.24 * size, 0.14 * size, 0.26 * size, "cinza_pedra", Vector3(-0.4 * size, 0, -0.25 * size), Vector3(0, 70, 0)))
	return r


## Montanha: base de mata, corpo de pedra e topo nevado, com a mesma inclinação nos três.
static func mountain(height: float = 7.0, radius: float = 3.6) -> Node3D:
	var m := Node3D.new()
	m.name = "Montanha"
	_add(m, LowPoly.pyramid(6, radius, height, "cinza_pedra"))
	_add(m, LowPoly.prism(6, radius * 1.02, radius * 0.7, height * 0.3, "verde_floresta"))
	var cap_start := 0.66
	_add(m, LowPoly.pyramid(6, radius * (1.0 - cap_start) * 1.02, height * (1.0 - cap_start) * 1.01, "cinza_claro", Vector3(0, height * cap_start, 0)))
	return m


## Trecho de rio com margens de areia e espuma. Origem no centro, correndo ao longo de X.
static func river(length: float = 6.0, width: float = 1.8) -> Node3D:
	var r := Node3D.new()
	r.name = "Rio"
	# A água fica um pouco acima do chão e as margens também, para o chão não esconder o rio.
	_add(r, LowPoly.box(Vector3(length, 0.12, width), "azul_agua", Vector3(0, -0.01, 0)))
	var steps := maxi(5, int(length / 1.2))
	for i in steps:
		_add(r, LowPoly.box(Vector3(0.6, 0.02, 0.06), "espuma", Vector3(-length / 2.0 + 0.7 + i * (length / float(steps)), 0.056, -width * 0.22 + 0.3 * (i % 3)), Vector3(0, 8 * (i % 2) - 4, 0)))
	for sz in [-1.0, 1.0]:
		_add(r, LowPoly.box(Vector3(length, 0.14, 0.45), "bege", Vector3(0, -0.04, sz * (width / 2.0 + 0.2))))
	_add(r, LowPoly.prism(5, 0.2, 0.14, 0.14, "cinza_pedra", Vector3(-1.2, 0, 0.3)))
	_add(r, LowPoly.prism(4, 0.16, 0.1, 0.12, "cinza_grafite", Vector3(1.5, 0, -0.35)))
	return r


## Cachoeira: paredão de pedra, queda d'água e poça de espuma. Origem no pé do paredão, queda voltada para +Z.
static func waterfall() -> Node3D:
	var w := Node3D.new()
	w.name = "Cachoeira"
	_add(w, LowPoly.box(Vector3(2.0, 1.6, 0.9), "cinza_pedra", Vector3(0, 0.8, -0.2)))
	_add(w, LowPoly.box(Vector3(0.7, 1.62, 0.1), "azul_agua", Vector3(0, 0.81, 0.3)))
	_add(w, LowPoly.box(Vector3(0.7, 0.05, 0.3), "azul_agua", Vector3(0, 1.62, 0.15)))
	_add(w, LowPoly.box(Vector3(1.4, 0.08, 0.9), "azul_agua", Vector3(0, 0.0, 0.8)))
	_add(w, LowPoly.box(Vector3(0.9, 0.06, 0.3), "espuma", Vector3(0, 0.1, 0.4)))
	return w


## Capivara.
static func capybara() -> Node3D:
	var a := Node3D.new()
	a.name = "Capivara"
	_add(a, LowPoly.box(Vector3(0.85, 0.42, 0.46), "marrom", Vector3(0, 0.42, 0)))
	_add(a, LowPoly.box(Vector3(0.3, 0.3, 0.34), "marrom", Vector3(0.52, 0.5, 0)))
	_add(a, LowPoly.box(Vector3(0.14, 0.18, 0.3), "marrom_escuro", Vector3(0.7, 0.45, 0)))
	_add(a, LowPoly.box(Vector3(0.05, 0.05, 0.03), "tinta", Vector3(0.62, 0.58, 0.18)))
	_add(a, LowPoly.box(Vector3(0.05, 0.05, 0.03), "tinta", Vector3(0.62, 0.58, -0.18)))
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			_add(a, LowPoly.box(Vector3(0.12, 0.22, 0.12), "marrom_escuro", Vector3(sx * 0.28, 0.11, sz * 0.15)))
	_add(a, LowPoly.box(Vector3(0.1, 0.1, 0.06), "marrom_escuro", Vector3(0.48, 0.7, 0.12)))
	_add(a, LowPoly.box(Vector3(0.1, 0.1, 0.06), "marrom_escuro", Vector3(0.48, 0.7, -0.12)))
	return a


## Arara-vermelha pousada em um galho. Origem na base do galho.
static func macaw() -> Node3D:
	var a := Node3D.new()
	a.name = "Arara"
	_add(a, LowPoly.box(Vector3(0.7, 0.07, 0.07), "marrom_escuro", Vector3(0, 0.0, 0)))
	_add(a, LowPoly.box(Vector3(0.22, 0.4, 0.2), "vermelho", Vector3(0, 0.27, 0), Vector3(0, 0, 8)))
	_add(a, LowPoly.box(Vector3(0.2, 0.2, 0.2), "vermelho", Vector3(0.04, 0.55, 0)))
	_add(a, LowPoly.prism(3, 0.07, 0.07, 0.14, "bege", Vector3(0.18, 0.55, 0), Vector3(0, 0, -90)))
	_add(a, LowPoly.box(Vector3(0.05, 0.05, 0.03), "tinta", Vector3(0.1, 0.59, 0.11)))
	_add(a, LowPoly.box(Vector3(0.05, 0.05, 0.03), "tinta", Vector3(0.1, 0.59, -0.11)))
	for sz in [-1.0, 1.0]:
		_add(a, LowPoly.box(Vector3(0.1, 0.32, 0.04), "azul_flor", Vector3(-0.02, 0.28, sz * 0.12), Vector3(sz * 6, 0, 4)))
		_add(a, LowPoly.box(Vector3(0.1, 0.1, 0.04), "amarelo_lenco", Vector3(-0.02, 0.4, sz * 0.12), Vector3(sz * 6, 0, 4)))
	_add(a, LowPoly.box(Vector3(0.08, 0.5, 0.05), "vermelho", Vector3(-0.1, -0.02, 0.02), Vector3(0, 0, 10)))
	_add(a, LowPoly.box(Vector3(0.05, 0.4, 0.04), "azul_flor", Vector3(-0.12, -0.05, -0.03), Vector3(0, 0, 10)))
	return a


## Veado com chifres.
static func deer() -> Node3D:
	var a := Node3D.new()
	a.name = "Veado"
	_add(a, LowPoly.box(Vector3(0.8, 0.4, 0.3), "marrom", Vector3(0, 0.72, 0)))
	_add(a, LowPoly.box(Vector3(0.14, 0.4, 0.16), "marrom", Vector3(0.42, 0.98, 0), Vector3(0, 0, -15)))
	_add(a, LowPoly.box(Vector3(0.3, 0.22, 0.2), "marrom", Vector3(0.58, 1.2, 0)))
	_add(a, LowPoly.box(Vector3(0.1, 0.1, 0.12), "tinta", Vector3(0.74, 1.18, 0)))
	_add(a, LowPoly.box(Vector3(0.04, 0.05, 0.03), "tinta", Vector3(0.62, 1.24, 0.1)))
	_add(a, LowPoly.box(Vector3(0.04, 0.05, 0.03), "tinta", Vector3(0.62, 1.24, -0.1)))
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			_add(a, LowPoly.box(Vector3(0.09, 0.55, 0.09), "marrom_escuro", Vector3(sx * 0.3, 0.27, sz * 0.09)))
	for sz in [-1.0, 1.0]:
		_add(a, LowPoly.box(Vector3(0.04, 0.3, 0.04), "bege", Vector3(0.5, 1.45, sz * 0.07), Vector3(sz * 12, 0, 10)))
		_add(a, LowPoly.box(Vector3(0.04, 0.14, 0.04), "bege", Vector3(0.45, 1.5, sz * 0.12), Vector3(sz * 12, 0, 40)))
	_add(a, LowPoly.box(Vector3(0.12, 0.1, 0.1), "bege", Vector3(-0.44, 0.78, 0)))
	return a
