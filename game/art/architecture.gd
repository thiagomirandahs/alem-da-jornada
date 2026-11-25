class_name Architecture
extends RefCounted
## Arquitetura e objetos dos universos de José (Egito) e de Daniel (Babilônia). Origem no chão, 1 unidade = 1 metro.
## Mesma linguagem dos personagens: troncos de pirâmide (paredes inclinadas), prismas e pirâmides, faces planas, cores só da
## Palette. Simplificações inspiradas no Egito e na Babilônia antigos, a revisar com quem conheça o período. Sem item moderno.


static func _add(parent: Node3D, child: Node3D) -> Node3D:
	parent.add_child(child)
	return child


static func _fr(parent: Node3D, base: Vector2, top: Vector2, height: float, color: String, pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> Node3D:
	return _add(parent, LowPoly.frustum(base, top, height, color, pos, rot))


## Faixa que acompanha a inclinação de uma parede (base e topo da parede, altura total, altura e posição da faixa).
static func _band(parent: Node3D, base: Vector2, top: Vector2, total: float, y: float, band_h: float, color: String, pad: float = 0.05) -> void:
	var low := base.lerp(top, y / total) + Vector2(pad, pad)
	var high := base.lerp(top, (y + band_h) / total) + Vector2(pad, pad)
	_fr(parent, low, high, band_h, color, Vector3(0, y, 0))


# ---------------------------------------------------------------- Egito

## Casa de adobe: paredes inclinadas, beiral de ocre, quarto no terraço, porta e duas janelas.
static func egypt_house(w: float = 3.4, d: float = 3.0, h: float = 2.3) -> Node3D:
	var n := Node3D.new()
	n.name = "CasaEgito"
	_fr(n, Vector2(w, d), Vector2(w * 0.86, d * 0.86), h, "adobe")
	_fr(n, Vector2(w * 0.88, d * 0.88), Vector2(w * 0.94, d * 0.94), 0.2, "ocre", Vector3(0, h, 0))
	_fr(n, Vector2(1.0, 1.0), Vector2(0.88, 0.88), 0.6, "adobe", Vector3(-w * 0.2, h + 0.2, -d * 0.18))
	_fr(n, Vector2(1.06, 1.06), Vector2(1.1, 1.1), 0.1, "ocre", Vector3(-w * 0.2, h + 0.8, -d * 0.18))
	var z_at := func(y: float) -> float: return d / 2.0 - d * 0.07 * (y / h) # a parede da frente é inclinada
	_fr(n, Vector2(0.8, 0.16), Vector2(0.66, 0.16), 1.5, "marrom_escuro", Vector3(0, 0, z_at.call(0.75)))
	_fr(n, Vector2(1.0, 0.2), Vector2(0.96, 0.2), 0.14, "ocre", Vector3(0, 1.5, z_at.call(1.55)))
	for side in [-1.0, 1.0]:
		_fr(n, Vector2(0.4, 0.16), Vector2(0.34, 0.16), 0.36, "marrom_escuro", Vector3(side * w * 0.3, 1.4, z_at.call(1.6)))
	return n


## Coluna de papiro: base, fuste afunilado em linho com faixas azul e dourada, capitel em botão e ábaco.
static func egypt_column(h: float = 3.2) -> Node3D:
	var c := Node3D.new()
	c.name = "ColunaPapiro"
	var r_bottom := 0.26
	var r_top := 0.19
	var base_h := 0.18
	var cap_h := 0.5
	var shaft_h := h - base_h - cap_h - 0.14
	_add(c, LowPoly.prism(8, 0.42, 0.34, base_h, "adobe"))
	_add(c, LowPoly.prism(8, r_bottom, r_top, shaft_h, "linho", Vector3(0, base_h, 0)))
	for t in [0.12, 0.5, 0.88]:
		var r := lerpf(r_bottom, r_top, t) + 0.012
		_add(c, LowPoly.prism(8, r, r, 0.07, "dourado_trigo" if t == 0.5 else "azul_nilo", Vector3(0, base_h + shaft_h * t, 0)))
	_add(c, LowPoly.prism(8, r_top, 0.36, cap_h, "terracota", Vector3(0, base_h + shaft_h, 0)))
	_fr(c, Vector2(0.78, 0.78), Vector2(0.72, 0.72), 0.14, "ocre", Vector3(0, h - 0.14, 0))
	return c


## Celeiro de cúpula em degraus, com porta voltada para +X.
static func granary(r: float = 1.5, h: float = 2.6) -> Node3D:
	var g := Node3D.new()
	g.name = "Celeiro"
	_add(g, LowPoly.prism(10, r, r * 0.92, h * 0.5, "adobe"))
	_add(g, LowPoly.prism(10, r * 0.92, r * 0.72, h * 0.2, "adobe", Vector3(0, h * 0.5, 0)))
	_add(g, LowPoly.prism(10, r * 0.72, r * 0.42, h * 0.18, "ocre", Vector3(0, h * 0.7, 0)))
	_add(g, LowPoly.pyramid(10, r * 0.42, h * 0.22, "adobe", Vector3(0, h * 0.88, 0)))
	_add(g, LowPoly.prism(10, 0.12, 0.08, 0.14, "ocre", Vector3(0, h * 1.1, 0)))
	_fr(g, Vector2(0.14, 0.7), Vector2(0.12, 0.56), 1.1, "marrom_escuro", Vector3(r * 0.92, 0, 0))
	return g


## Palácio do administrador: plataforma, sala com cornija, pórtico de quatro colunas e dois pilones com bandeiras.
static func egypt_palace(w: float = 9.0) -> Node3D:
	var p := Node3D.new()
	p.name = "PalacioEgito"
	var y0 := 0.4
	_fr(p, Vector2(w, 4.6), Vector2(w * 0.95, 4.2), y0, "bege")
	_fr(p, Vector2(w * 0.82, 3.0), Vector2(w * 0.74, 2.6), 3.2, "adobe", Vector3(0, y0, -0.5))
	_fr(p, Vector2(w * 0.76, 2.7), Vector2(w * 0.84, 3.0), 0.3, "ocre", Vector3(0, y0 + 3.2, -0.5))
	_fr(p, Vector2(1.4, 0.2), Vector2(1.2, 0.2), 2.3, "marrom_escuro", Vector3(0, y0, 1.0))
	for x in [-w * 0.3, -w * 0.12, w * 0.12, w * 0.3]:
		var column := egypt_column(3.0)
		column.position = Vector3(x, y0, 1.4)
		_add(p, column)
	_fr(p, Vector2(w * 0.7, 0.9), Vector2(w * 0.66, 0.8), 0.32, "dourado_trigo", Vector3(0, y0 + 3.0, 1.4))
	for side in [-1.0, 1.0]:
		var x: float = side * (w * 0.41 + 0.35)
		_fr(p, Vector2(1.7, 1.6), Vector2(1.2, 1.2), 4.2, "adobe", Vector3(x, y0, 0.2))
		_fr(p, Vector2(1.3, 1.3), Vector2(1.5, 1.5), 0.25, "ocre", Vector3(x, y0 + 4.2, 0.2))
		var pole := banner_pole(5.2, "azul_nilo" if side < 0 else "terracota")
		pole.position = Vector3(x, y0 + 4.45, 1.2)
		_add(p, pole)
	return p


static func obelisk(h: float = 4.0) -> Node3D:
	var o := Node3D.new()
	o.name = "Obelisco"
	_fr(o, Vector2(0.9, 0.9), Vector2(0.7, 0.7), 0.25, "ocre")
	_fr(o, Vector2(0.55, 0.55), Vector2(0.3, 0.3), h, "adobe", Vector3(0, 0.25, 0))
	_add(o, LowPoly.pyramid(4, 0.3 / sqrt(2.0), 0.35, "dourado_trigo", Vector3(0, 0.25 + h, 0)))
	return o


## Barraca de feira: quatro postes, toldo de terracota, balcão e potes.
static func market_stall() -> Node3D:
	var s := Node3D.new()
	s.name = "BarracaEgito"
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			_add(s, LowPoly.prism(5, 0.06, 0.05, 2.1, "marrom_escuro", Vector3(sx * 1.0, 0, sz * 0.7)))
	_fr(s, Vector2(2.6, 1.9), Vector2(2.0, 1.3), 0.3, "terracota", Vector3(0, 2.1, 0))
	_fr(s, Vector2(2.0, 0.7), Vector2(1.9, 0.62), 0.85, "adobe", Vector3(0, 0, 0.1))
	for i in 3:
		var pot := jar(0.5 + 0.08 * (i % 2))
		pot.position = Vector3(-0.6 + i * 0.6, 0.85, 0.1)
		_add(s, pot)
	return s


static func jar(h: float = 0.5) -> Node3D:
	var j := Node3D.new()
	j.name = "Pote"
	_add(j, LowPoly.prism(8, 0.14 * h / 0.5, 0.2 * h / 0.5, h * 0.55, "terracota"))
	_add(j, LowPoly.prism(8, 0.2 * h / 0.5, 0.1 * h / 0.5, h * 0.35, "terracota", Vector3(0, h * 0.55, 0)))
	_add(j, LowPoly.prism(8, 0.1 * h / 0.5, 0.12 * h / 0.5, h * 0.1, "ocre", Vector3(0, h * 0.9, 0)))
	return j


static func grain_basket() -> Node3D:
	var b := Node3D.new()
	b.name = "CestoDeGraos"
	_add(b, LowPoly.prism(8, 0.2, 0.28, 0.25, "adobe"))
	_add(b, LowPoly.pyramid(8, 0.27, 0.16, "dourado_trigo", Vector3(0, 0.25, 0)))
	return b


## Canteiro de trigo: fileiras de espigas em pirâmides finas.
static func wheat_patch(rows: int = 4, per_row: int = 6) -> Node3D:
	var w := Node3D.new()
	w.name = "Trigo"
	for r in rows:
		for i in per_row:
			var tilt := 6.0 * ((r + i) % 3 - 1)
			_add(w, LowPoly.pyramid(3, 0.05, 0.5 + 0.06 * ((r * 3 + i) % 3), "dourado_trigo" if (r + i) % 2 == 0 else "ocre", Vector3(i * 0.3, 0, r * 0.45), Vector3(tilt, 0, -tilt)))
	return w


## Pirâmide ao longe: só silhueta, faces de duas cores.
static func far_pyramid(h: float = 22.0) -> Node3D:
	var p := Node3D.new()
	p.name = "PiramideAoLonge"
	_add(p, LowPoly.pyramid(4, h * 1.1, h, "ocre"))
	return p


# ------------------------------------------------------------- Babilônia

## Mastro com flâmula (a flâmula aponta para +Z).
static func banner_pole(h: float = 3.0, color: String = "azul_lapis") -> Node3D:
	var b := Node3D.new()
	b.name = "Mastro"
	_add(b, LowPoly.prism(5, 0.045, 0.035, h, "marrom_escuro"))
	_fr(b, Vector2(0.03, 0.55), Vector2(0.03, 0.22), 0.7, color, Vector3(0, h - 0.1, 0), Vector3(-90, 0, 0))
	return b


## Torre de tijolo com faixa vitrificada azul, frisos dourados, relevos geométricos e ameias.
static func babylon_tower(h: float = 5.5, w: float = 2.6) -> Node3D:
	var t := Node3D.new()
	t.name = "TorreBabilonia"
	var base := Vector2(w, w)
	var top := Vector2(w * 0.84, w * 0.84)
	_fr(t, base, top, h, "tijolo")
	var y := h * 0.5
	_band(t, base, top, h, y, 0.9, "azul_lapis")
	_band(t, base, top, h, y - 0.14, 0.1, "dourado_antigo", 0.07)
	_band(t, base, top, h, y + 0.94, 0.1, "dourado_antigo", 0.07)
	var depth := lerpf(w, w * 0.84, (y + 0.45) / h) / 2.0 + 0.05
	for k in 4:
		var face := Node3D.new()
		face.rotation_degrees.y = k * 90.0
		_add(t, face)
		for x in [-0.5, 0.5]:
			_fr(face, Vector2(0.4, 0.06), Vector2(0.34, 0.06), 0.4, "creme", Vector3(x, y + 0.25, depth))
	_fr(t, Vector2(top.x + 0.2, top.y + 0.2), Vector2(top.x + 0.3, top.y + 0.3), 0.2, "dourado_antigo", Vector3(0, h, 0))
	var edge := top.x / 2.0 - 0.15
	for x in [-edge, 0.0, edge]:
		for z in [-edge, 0.0, edge]:
			if absf(x) + absf(z) > 0.01:
				_fr(t, Vector2(0.4, 0.4), Vector2(0.32, 0.32), 0.45, "tijolo", Vector3(x, h + 0.2, z))
	return t


## Muralha de tijolo com friso azul e ameias na frente. Corre ao longo de X, frente voltada para +Z.
static func city_wall(length: float = 8.0, h: float = 3.2) -> Node3D:
	var m := Node3D.new()
	m.name = "Muralha"
	var base := Vector2(length, 1.6)
	var top := Vector2(length * 0.98, 1.2)
	_fr(m, base, top, h, "tijolo")
	_band(m, base, top, h, h * 0.45, 0.5, "azul_lapis", 0.04)
	_band(m, base, top, h, h * 0.45 + 0.52, 0.08, "dourado_antigo", 0.05)
	_fr(m, Vector2(top.x + 0.1, top.y + 0.1), Vector2(top.x + 0.2, top.y + 0.2), 0.18, "dourado_antigo", Vector3(0, h, 0))
	var n := maxi(3, int(length / 1.0))
	for i in n:
		_fr(m, Vector2(0.5, 0.4), Vector2(0.4, 0.32), 0.5, "tijolo", Vector3(-length * 0.49 + (i + 0.5) * (length * 0.98 / n), h + 0.18, top.y / 2.0 - 0.1))
	return m


## Portão inspirado no de Ishtar: duas torres azuis com frisos dourados e relevos geométricos, e um lintel por cima da passagem.
static func babylon_gate(w: float = 7.0) -> Node3D:
	var g := Node3D.new()
	g.name = "PortaoBabilonia"
	var tower_w := 2.2
	for side in [-1.0, 1.0]:
		var t := _tower_glazed(6.0, tower_w)
		t.position = Vector3(side * (w / 2.0 - tower_w / 2.0), 0, 0)
		_add(g, t)
	var gap := w - tower_w * 2.0
	_fr(g, Vector2(gap + 0.4, tower_w * 0.9), Vector2(gap + 0.2, tower_w * 0.8), 1.5, "azul_lapis", Vector3(0, 3.9, 0))
	_fr(g, Vector2(gap + 0.5, tower_w * 0.95), Vector2(gap + 0.5, tower_w * 0.95), 0.14, "dourado_antigo", Vector3(0, 5.4, 0))
	var n := 5
	for i in n:
		_fr(g, Vector2(0.5, 0.06), Vector2(0.4, 0.06), 0.5, "creme" if i % 2 == 0 else "dourado_antigo", Vector3(-gap / 2.0 + 0.3 + i * ((gap - 0.6) / (n - 1)), 4.35, tower_w * 0.45 + 0.02))
	return g


## Torre azul vitrificada (usada no portão): mais colorida que a torre de tijolo da muralha.
static func _tower_glazed(h: float, w: float) -> Node3D:
	var t := Node3D.new()
	t.name = "TorreAzul"
	var base := Vector2(w, w)
	var top := Vector2(w * 0.86, w * 0.86)
	_fr(t, base, top, h, "azul_lapis")
	for y in [0.9, 2.4, 3.9]:
		_band(t, base, top, h, y, 0.14, "dourado_antigo", 0.04)
	var face := Node3D.new()
	_add(t, face)
	for row in [1.35, 2.85, 4.35]:
		var depth := lerpf(w, w * 0.86, row / h) / 2.0 + 0.04
		_fr(face, Vector2(0.5, 0.06), Vector2(0.42, 0.06), 0.5, "creme", Vector3(0, row, depth))
	_fr(t, Vector2(top.x + 0.2, top.y + 0.2), Vector2(top.x + 0.3, top.y + 0.3), 0.2, "dourado_antigo", Vector3(0, h, 0))
	var edge := top.x / 2.0 - 0.15
	for x in [-edge, 0.0, edge]:
		_fr(t, Vector2(0.36, 0.36), Vector2(0.3, 0.3), 0.4, "azul_lapis", Vector3(x, h + 0.2, edge))
	return t


## Zigurate em degraus com escada de frente e santuário azul no topo.
static func ziggurat(tiers: int = 3) -> Node3D:
	var z := Node3D.new()
	z.name = "Zigurate"
	var colors := ["tijolo", "ocre", "tijolo"]
	var size := 7.0
	var y := 0.0
	for i in tiers:
		var step_h := 1.6
		_fr(z, Vector2(size, size), Vector2(size * 0.9, size * 0.9), step_h, colors[i % colors.size()], Vector3(0, y, 0))
		size *= 0.68
		y += step_h
	_fr(z, Vector2(size * 0.9, size * 0.9), Vector2(size * 0.7, size * 0.7), 1.2, "azul_lapis", Vector3(0, y, 0))
	_fr(z, Vector2(size * 0.72, size * 0.72), Vector2(size * 0.78, size * 0.78), 0.14, "dourado_antigo", Vector3(0, y + 1.2, 0))
	for i in 6: # escada: cada degrau avança menos que o de baixo e encosta na parede inclinada
		var step_y := i * 0.27
		var step_len := 1.4 - i * 0.2
		_fr(z, Vector2(1.3, step_len), Vector2(1.3, step_len * 0.95), 0.27, "bege", Vector3(0, step_y, 3.5 - 0.35 * (step_y / 1.6) + step_len / 2.0 - 0.05))
	return z


## Casa de pátio de tijolo, com friso claro, porta com lintel azul e ameias baixas no terraço.
static func babylon_house(w: float = 4.0, d: float = 3.6, h: float = 2.6) -> Node3D:
	var n := Node3D.new()
	n.name = "CasaBabilonia"
	_fr(n, Vector2(w, d), Vector2(w * 0.9, d * 0.9), h, "tijolo")
	_band(n, Vector2(w, d), Vector2(w * 0.9, d * 0.9), h, h * 0.55, 0.12, "creme", 0.04)
	_fr(n, Vector2(w * 0.92, d * 0.92), Vector2(w * 0.97, d * 0.97), 0.18, "dourado_antigo", Vector3(0, h, 0))
	var z_at := func(y: float) -> float: return d / 2.0 - d * 0.05 * (y / h)
	_fr(n, Vector2(0.9, 0.16), Vector2(0.74, 0.16), 1.7, "marrom_escuro", Vector3(0, 0, z_at.call(0.85)))
	_fr(n, Vector2(1.2, 0.22), Vector2(1.2, 0.22), 0.22, "azul_lapis", Vector3(0, 1.7, z_at.call(1.8)))
	for side in [-1.0, 1.0]:
		_fr(n, Vector2(0.36, 0.16), Vector2(0.3, 0.16), 0.4, "marrom_escuro", Vector3(side * w * 0.3, 1.5, z_at.call(1.7)))
		for i in 3:
			_fr(n, Vector2(0.4, 0.36), Vector2(0.32, 0.3), 0.36, "tijolo", Vector3(side * w * 0.28 + (i - 1) * 0.6 * side, h + 0.18, d * 0.4))
	return n


## Jardim em terraços: degraus de pedra clara cobertos de verde, com arbustos.
static func garden_terrace(tiers: int = 3) -> Node3D:
	var g := Node3D.new()
	g.name = "JardimEmTerracos"
	var size := Vector2(7.0, 5.0)
	var y := 0.0
	for i in tiers:
		_fr(g, size, size * 0.92, 1.2, "bege", Vector3(0, y, 0))
		_fr(g, size * 0.93, size * 0.93, 0.12, "verde_jardim", Vector3(0, y + 1.2, 0))
		for k in 4:
			var bush := LowPoly.prism(6, 0.42, 0.28, 0.5, "verde_jardim", Vector3((k - 1.5) * size.x * 0.22, y + 1.3, size.y * 0.3), Vector3(0, k * 25.0, 0))
			_add(g, bush)
		size *= 0.74
		y += 1.32
	return g


## Tabuleta de argila em pé, com linhas de escrita.
static func clay_tablet() -> Node3D:
	var t := Node3D.new()
	t.name = "TabuletaDeArgila"
	_fr(t, Vector2(0.28, 0.07), Vector2(0.24, 0.06), 0.36, "adobe")
	for i in 4:
		_fr(t, Vector2(0.18, 0.02), Vector2(0.18, 0.02), 0.025, "marrom_escuro", Vector3(0, 0.07 + i * 0.07, 0.04))
	return t


## Rolo de papiro ou pergaminho, deitado.
static func scroll() -> Node3D:
	var s := Node3D.new()
	s.name = "Rolo"
	_add(s, LowPoly.prism(8, 0.05, 0.05, 0.42, "linho", Vector3(-0.21, 0.06, 0), Vector3(0, 0, -90)))
	for sx in [-1.0, 1.0]:
		_add(s, LowPoly.prism(8, 0.065, 0.065, 0.03, "ocre", Vector3(sx * 0.21 - (0.03 if sx > 0 else 0.0), 0.06, 0), Vector3(0, 0, -90)))
	return s
