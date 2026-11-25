class_name Fx
extends RefCounted
## Efeitos visuais low-poly: água, raios de luz, poeira, folhas, fogo e neblina. Origem no chão, 1 unidade = 1 metro.
## As partículas são formas facetadas da mesma família dos modelos; só mudam o material (translúcido, sem sombra).


static func _add(parent: Node3D, child: Node3D) -> Node3D:
	parent.add_child(child)
	return child


## Peça de efeito: forma facetada com material translúcido da paleta.
static func glow(mesh: Mesh, color_name: String, alpha: float, pos: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	n.mesh = mesh
	n.material_override = LowPoly.effect_material(color_name, alpha)
	n.position = pos
	n.rotation_degrees = rot_deg
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	n.set_meta("lowpoly", true)
	n.set_meta("effect", true)
	return n


## Água estilizada: poça com cristas de espuma em fileiras e anéis de ondulação.
static func water() -> Node3D:
	var w := Node3D.new()
	w.name = "Agua"
	_add(w, LowPoly.box(Vector3(2.8, 0.2, 2.8), "azul_agua", Vector3(0, 0.1, 0)))
	for row in 4:
		for i in 3:
			var x := -0.9 + i * 0.9 + (0.4 if row % 2 == 1 else 0.0)
			_add(w, LowPoly.box(Vector3(0.45, 0.02, 0.06), "espuma", Vector3(x - 0.2, 0.215, -1.0 + row * 0.62)))
	for r in [0.38, 0.62, 0.86]:
		_add(w, glow(LowPoly.prism_mesh(8, r, r, 0.02), "espuma", 0.55 - r * 0.3, Vector3(0.3, 0.215, 0.2)))
	_add(w, LowPoly.prism(5, 0.28, 0.2, 0.3, "cinza_pedra", Vector3(0.3, 0.12, 0.2)))
	return w


## Raios de luz atravessando a copa: faixas inclinadas, mais largas embaixo.
static func light_shafts() -> Node3D:
	var l := Node3D.new()
	l.name = "RaiosDeLuz"
	for i in 4:
		var x := -0.9 + i * 0.62
		_add(l, glow(LowPoly.prism_mesh(4, 0.1, 0.32, 3.0), "amarelo_brasa", 0.2 + 0.05 * (i % 2), Vector3(x, 0, 0.0), Vector3(0, 0, -16)))
	_add(l, LowPoly.box(Vector3(2.8, 0.1, 1.6), "verde_claro", Vector3(0, 0.05, 0)))
	_add(l, LowPoly.pyramid(6, 0.8, 1.1, "verde_floresta", Vector3(-1.1, 1.75, -0.6)))
	_add(l, LowPoly.pyramid(6, 0.7, 1.0, "verde_floresta", Vector3(0.9, 1.85, -0.7)))
	return l


## Poeira suspensa: cubinhos translúcidos espalhados num volume (sempre o mesmo arranjo).
static func dust() -> Node3D:
	var d := Node3D.new()
	d.name = "Poeira"
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	_add(d, LowPoly.box(Vector3(2.8, 0.1, 1.8), "bege", Vector3(0, 0.05, 0)))
	for i in 34:
		var s := rng.randf_range(0.03, 0.08)
		_add(d, glow(BoxMesh.new(), "creme", rng.randf_range(0.35, 0.8), Vector3(rng.randf_range(-1.2, 1.2), rng.randf_range(0.2, 2.2), rng.randf_range(-0.6, 0.6)), Vector3(rng.randf_range(0, 90), rng.randf_range(0, 90), 0)))
		(d.get_child(d.get_child_count() - 1) as MeshInstance3D).scale = Vector3.ONE * s
	return d


## Folhas caindo e um monte no chão: losangos finos em cores de folhagem e outono.
static func leaves() -> Node3D:
	var l := Node3D.new()
	l.name = "Folhas"
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var colors := ["verde_folha", "verde_claro", "amarelo_brasa", "laranja_fogo", "marrom"]
	_add(l, LowPoly.box(Vector3(2.8, 0.1, 1.8), "verde_claro", Vector3(0, 0.05, 0)))
	for i in 16:
		_add(l, LowPoly.prism(4, 0.1, 0.1, 0.012, colors[i % colors.size()], Vector3(rng.randf_range(-1.1, 1.1), rng.randf_range(0.5, 2.3), rng.randf_range(-0.6, 0.6)), Vector3(rng.randf_range(0, 360), rng.randf_range(0, 360), rng.randf_range(0, 360)), 0.0))
	for i in 12:
		_add(l, LowPoly.prism(4, 0.11, 0.11, 0.012, colors[i % colors.size()], Vector3(rng.randf_range(-0.5, 0.5), 0.12 + 0.012 * i, rng.randf_range(-0.3, 0.3)), Vector3(0, rng.randf_range(0, 360), 0)))
	return l


## Fogueira com faíscas e fumaça.
static func fire() -> Node3D:
	var f := Node3D.new()
	f.name = "Fogo"
	var camp := Props.campfire()
	camp.scale = Vector3.ONE * 1.4
	_add(f, camp)
	var rng := RandomNumberGenerator.new()
	rng.seed = 3
	for i in 14:
		var spark := glow(BoxMesh.new(), "amarelo_brasa", 0.95, Vector3(rng.randf_range(-0.5, 0.5), 1.1 + i * 0.1, rng.randf_range(-0.4, 0.4)))
		spark.scale = Vector3.ONE * rng.randf_range(0.03, 0.06)
		_add(f, spark)
	for i in 4:
		var r := 0.22 + i * 0.12
		_add(f, glow(LowPoly.prism_mesh(6, r, r, 0.22), "cinza_pedra", 0.42 - i * 0.07, Vector3(0.1 * i, 1.35 + i * 0.32, 0), Vector3(0, i * 20, 0)))
	return f


## Neblina rasteira e vaga-lumes: lajes translúcidas e pontos de luz com halo.
static func mist_fireflies() -> Node3D:
	var m := Node3D.new()
	m.name = "NeblinaEVagalumes"
	_add(m, LowPoly.box(Vector3(2.8, 0.1, 1.8), "verde_floresta", Vector3(0, 0.05, 0)))
	_add(m, LowPoly.pyramid(6, 0.7, 1.9, "verde_floresta", Vector3(-1.0, 0.1, -0.5)))
	_add(m, LowPoly.pyramid(6, 0.6, 1.6, "verde_floresta", Vector3(1.0, 0.1, -0.6)))
	for i in 3:
		_add(m, glow(BoxMesh.new(), "creme", 0.3 - i * 0.07, Vector3(0, 0.3 + i * 0.28, 0)))
		(m.get_child(m.get_child_count() - 1) as MeshInstance3D).scale = Vector3(2.9 - i * 0.3, 0.18, 1.9 - i * 0.2)
	var spots := [Vector3(-0.6, 1.1, 0.4), Vector3(0.2, 1.5, 0.1), Vector3(0.8, 0.9, 0.5), Vector3(-0.1, 0.8, 0.6), Vector3(0.5, 1.7, -0.3)]
	for p in spots:
		var halo := glow(BoxMesh.new(), "amarelo_brasa", 0.25, p)
		halo.scale = Vector3.ONE * 0.2
		_add(m, halo)
		var core := glow(BoxMesh.new(), "amarelo_brasa", 1.0, p)
		core.scale = Vector3.ONE * 0.06
		_add(m, core)
	return m
