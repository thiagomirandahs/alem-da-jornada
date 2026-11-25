class_name Board03Environment
extends RefCounted
## Prancha 3: Environment Design. Acampamento na floresta, com planos de profundidade, rio, ponte, montanhas e céu suave.


static func build() -> Node3D:
	var root := Node3D.new()
	Stage.light(root, Stage.Mood.MANHA, "", true)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7 # sempre a mesma floresta

	# Chão: grama, clareira de areia e trilha até o acampamento
	_add(root, LowPoly.box(Vector3(140, 0.5, 140), "verde_claro", Vector3(0, -0.25, -30)))
	_add(root, LowPoly.prism(10, 4.6, 4.6, 0.06, "bege"))

	# Rio ao fundo, com ponte e cachoeira
	var river := Nature.river(60.0, 5.0)
	river.position = Vector3(6, 0, -8.5)
	_add(root, river)
	var bridge := Props.bridge(5.6)
	bridge.position = Vector3(6.5, 0.32, -8.5)
	bridge.rotation_degrees.y = 90.0
	_add(root, bridge)
	var fall := Nature.waterfall()
	fall.position = Vector3(20, 0, -14)
	fall.scale = Vector3.ONE * 2.6
	_add(root, fall)

	# Acampamento: fogueira, barracas, toras, caixas, placa, corda e mochila
	var fire := Props.campfire()
	fire.scale = Vector3.ONE * 1.3
	_add(root, fire)
	var tent_a := Props.tent("bege")
	tent_a.position = Vector3(-4.0, 0, -2.4)
	tent_a.rotation_degrees.y = 30.0
	tent_a.scale = Vector3.ONE * 1.25
	_add(root, tent_a)
	var tent_b := Props.tent("marrom")
	tent_b.position = Vector3(-0.8, 0, -4.9)
	tent_b.rotation_degrees.y = 6.0
	tent_b.scale = Vector3.ONE * 1.25
	_add(root, tent_b)
	for i in 3:
		var a := i * 2.1 + 0.9
		_add(root, LowPoly.box(Vector3(1.2, 0.32, 0.36), "marrom_escuro", Vector3(cos(a) * 2.1, 0.16, sin(a) * 2.1), Vector3(0, -rad_to_deg(a) + 90.0, 0)))
	var crate := Props.crate()
	crate.position = Vector3(3.5, 0, -3.0)
	crate.rotation_degrees.y = 25.0
	_add(root, crate)
	var lantern := Props.lantern()
	lantern.position = Vector3(3.5, 0.45, -3.0)
	_add(root, lantern)
	var crate2 := Props.crate()
	crate2.position = Vector3(4.4, 0, -2.3)
	crate2.scale = Vector3.ONE * 0.8
	crate2.rotation_degrees.y = -10.0
	_add(root, crate2)
	var sign := Props.sign_post("TRILHA")
	sign.position = Vector3(6.2, 0, 3.6)
	sign.rotation_degrees.y = -30.0
	_add(root, sign)
	var rope := Props.rope()
	rope.position = Vector3(-2.2, 0.0, 2.6)
	_add(root, rope)
	var pack := Props.backpack()
	pack.position = Vector3(-3.4, 0.25, 1.4)
	pack.rotation_degrees = Vector3(0, 35, 0)
	pack.scale = Vector3.ONE * 1.1
	_add(root, pack)

	# Desbravadores em volta da fogueira, voltados para a roda e para quem olha
	var crew := [
		[Vector3(-1.9, 0, 0.7), 40.0, {"female": true, "skin": "pele_4", "hair": "cabelo_preto", "hair_style": "volume"}],
		[Vector3(1.0, 0, 2.1), -20.0, {"female": false, "skin": "pele_1", "hair": "cabelo_loiro", "hair_style": "franja"}],
		[Vector3(2.5, 0, 0.2), -55.0, {"female": true, "skin": "pele_2", "hair": "cabelo_ruivo", "hair_style": "trancas"}],
	]
	for member in crew:
		var person := Characters.build(member[2])
		person.position = member[0]
		person.rotation_degrees.y = member[1]
		_add(root, person)

	# Árvores grandes emoldurando a cena, perto da câmera
	for spec in [[-9.5, 5.5, 1.6, "pine"], [10.5, 4.0, 1.5, "pine"], [-13.0, 0.5, 1.4, "broad"], [14.0, -1.0, 1.3, "pine"], [-7.5, -7.0, 1.3, "pine"]]:
		var tree: Node3D = Nature.pine(3.8 * spec[2]) if spec[3] == "pine" else Nature.broadleaf(3.2 * spec[2])
		tree.position = Vector3(spec[0], 0, spec[1])
		_add(root, tree)
	# Floresta em camadas até o fundo, sem invadir a clareira nem o leito do rio
	_forest(root, rng, 150)
	# Montanhas ao fundo
	var peaks := [[-34, -80, 13.0, 6.0], [-14, -95, 19.0, 7.5], [8, -88, 14.0, 5.6], [30, -82, 18.0, 7.0], [56, -98, 12.0, 5.4]]
	for p in peaks:
		var mountain := Nature.mountain(p[2], p[3])
		mountain.position = Vector3(p[0], 0, p[1])
		_add(root, mountain)

	# Primeiro plano: flores, arbustos, pedras e capim, para a cena não ficar vazia
	for i in 26:
		var pos := Vector3(rng.randf_range(-12, 12), 0, rng.randf_range(3.0, 9.5))
		if pos.length() < 5.2 or (pos.x > 4.5 and pos.z < 6.5 and pos.x < 14.0 and pos.z > 3.0 and i % 2 == 0):
			continue
		var kind := i % 4
		var item: Node3D = Nature.flowers() if kind == 0 else (Nature.bush() if kind == 1 else (Nature.rock(0.8) if kind == 2 else Nature.grass()))
		item.position = pos
		item.rotation_degrees.y = rng.randf_range(0, 360)
		_add(root, item)

	Stage.camera(root, Vector3(0.0, 3.2, 12.0), Vector3(1.0, 2.6, -4.0), 48.0)
	root.add_child(BoardFrame.build(3, "Environment Design", "acampamento na floresta, em camadas"))
	return root


static func _add(parent: Node3D, child: Node3D) -> void:
	parent.add_child(child)


## Árvores espalhadas pelo fundo e pelas laterais, em três tipos.
static func _forest(root: Node3D, rng: RandomNumberGenerator, count: int) -> void:
	for i in count:
		var x := rng.randf_range(-38.0, 42.0)
		var z := rng.randf_range(-48.0, 8.0)
		if Vector2(x, z).length() < 7.5:
			continue # clareira
		if z < -4.5 and z > -12.5:
			continue # leito do rio
		if x > 4.0 and z > 2.0 and x < 15.0 and z < 9.5:
			continue # trilha
		var tree: Node3D
		match rng.randi() % 4:
			0, 1:
				tree = Nature.pine(rng.randf_range(3.0, 5.2))
			2:
				tree = Nature.broadleaf(rng.randf_range(2.8, 4.0))
			_:
				tree = Nature.palm(rng.randf_range(3.2, 4.4))
		tree.position = Vector3(x, 0, z)
		tree.rotation_degrees.y = rng.randf_range(0, 360)
		_add(root, tree)
