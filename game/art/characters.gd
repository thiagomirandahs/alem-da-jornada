class_name Characters
extends RefCounted
## Desbravadores low-poly bloqueados. Origem nos pés, frente voltada para +Z, 1 unidade = 1 metro.
## Cerca de 3,3 cabeças de altura (cabeça ligeiramente maior que o real, como pede o guia).
## Todo o corpo é feito de caixas e prismas do LowPoly, com cores só da Palette.

const HEIGHT := 1.5

const HAIR_STYLES: Array[String] = ["curto", "franja", "rabo", "trancas", "volume"]


## opts: skin, hair, hair_style, female, shirt, pants. Qualquer chave ausente usa o padrão.
static func build(opts: Dictionary = {}) -> Node3D:
	var skin: String = opts.get("skin", "pele_2")
	var hair: String = opts.get("hair", "cabelo_castanho")
	var style: String = opts.get("hair_style", "curto")
	var female: bool = opts.get("female", false)
	var shirt: String = opts.get("shirt", "bege")
	var pants: String = opts.get("pants", "verde_floresta")
	var torso_w := 0.46 if female else 0.5

	var root := Node3D.new()
	root.name = "Desbravadora" if female else "Desbravador"

	# Pernas, botas e solas
	for side in [-1.0, 1.0]:
		var x: float = side * 0.12
		root.add_child(LowPoly.box(Vector3(0.21, 0.4, 0.22), pants, Vector3(x, 0.36, 0.0)))
		var boot := Props.boot()
		boot.position = Vector3(x, 0.0, 0.0)
		root.add_child(boot)

	# Tronco, cinto e colarinho
	root.add_child(LowPoly.box(Vector3(torso_w, 0.5, 0.3), shirt, Vector3(0, 0.79, 0)))
	root.add_child(LowPoly.box(Vector3(torso_w + 0.01, 0.06, 0.31), "marrom_escuro", Vector3(0, 0.57, 0)))
	root.add_child(LowPoly.box(Vector3(0.07, 0.05, 0.02), "amarelo_brasa", Vector3(0, 0.57, 0.16)))

	# Braços: manga, antebraço e mão
	for side in [-1.0, 1.0]:
		var x: float = side * (torso_w / 2.0 + 0.09)
		root.add_child(LowPoly.box(Vector3(0.18, 0.22, 0.2), shirt, Vector3(x, 0.93, 0.0)))
		root.add_child(LowPoly.box(Vector3(0.13, 0.22, 0.14), skin, Vector3(x, 0.72, 0.0)))
		root.add_child(LowPoly.box(Vector3(0.15, 0.12, 0.16), skin, Vector3(x, 0.55, 0.0)))

	# Pescoço e lenço: faixa amarela ao redor do pescoço e ponta triangular sobre o peito, com acabamento vermelho
	root.add_child(LowPoly.box(Vector3(0.16, 0.08, 0.16), skin, Vector3(0, 1.07, 0)))
	root.add_child(LowPoly.box(Vector3(0.32, 0.1, 0.36), "amarelo_lenco", Vector3(0, 1.0, 0.0)))
	# Ponta do lenço sobre o peito, apontando para baixo: o vermelho (borda) um pouco maior, atrás do amarelo
	root.add_child(LowPoly.prism(3, 0.2, 0.2, 0.03, "vermelho", Vector3(0, 0.86, 0.155), Vector3(90, 0, 0), 30.0))
	root.add_child(LowPoly.prism(3, 0.15, 0.15, 0.03, "amarelo_lenco", Vector3(0, 0.868, 0.17), Vector3(90, 0, 0), 30.0))
	root.add_child(LowPoly.box(Vector3(0.06, 0.06, 0.03), "vermelho", Vector3(0, 0.97, 0.185))) # argola do lenço

	# Cabeça e rosto
	root.add_child(LowPoly.box(Vector3(0.46, 0.44, 0.44), skin, Vector3(0, 1.28, 0)))
	_face(root, skin, hair)
	_hair(root, hair, style)

	# Mochila de exploração (com esteira) e alças sobre os ombros
	var pack := Props.backpack()
	pack.position = Vector3(0, 0.84, -0.25)
	root.add_child(pack)
	for side in [-1.0, 1.0]:
		root.add_child(LowPoly.box(Vector3(0.07, 0.5, 0.03), "marrom_escuro", Vector3(side * 0.15, 0.86, 0.16)))
	# Cantil no quadril
	var canteen := Props.canteen()
	canteen.position = Vector3(torso_w / 2.0 + 0.04, 0.48, -0.02)
	root.add_child(canteen)
	return root


static func _face(root: Node3D, _skin: String, hair: String) -> void:
	var z := 0.225
	for side in [-1.0, 1.0]:
		root.add_child(LowPoly.box(Vector3(0.06, 0.09, 0.02), "tinta", Vector3(side * 0.1, 1.29, z)))
		root.add_child(LowPoly.box(Vector3(0.05, 0.05, 0.015), "espuma", Vector3(side * 0.1 + side * 0.012, 1.31, z + 0.003)))
		root.add_child(LowPoly.box(Vector3(0.11, 0.025, 0.02), hair, Vector3(side * 0.1, 1.38, z), Vector3(0, 0, side * -8)))
		root.add_child(LowPoly.box(Vector3(0.08, 0.045, 0.02), "rosa_bochecha", Vector3(side * 0.16, 1.2, z)))
	root.add_child(LowPoly.box(Vector3(0.06, 0.07, 0.05), _skin, Vector3(0, 1.22, z + 0.02)))
	# Sorriso: faixa central e pontas levantadas
	root.add_child(LowPoly.box(Vector3(0.1, 0.025, 0.02), "tinta", Vector3(0, 1.14, z)))
	for side in [-1.0, 1.0]:
		root.add_child(LowPoly.box(Vector3(0.025, 0.03, 0.02), "tinta", Vector3(side * 0.065, 1.155, z)))


static func _hair(root: Node3D, hair: String, style: String) -> void:
	# Base comum: calota sobre a cabeça e nuca
	root.add_child(LowPoly.box(Vector3(0.5, 0.14, 0.48), hair, Vector3(0, 1.5, 0)))
	root.add_child(LowPoly.box(Vector3(0.48, 0.3, 0.1), hair, Vector3(0, 1.36, -0.21)))
	for side in [-1.0, 1.0]:
		root.add_child(LowPoly.box(Vector3(0.05, 0.2, 0.3), hair, Vector3(side * 0.245, 1.38, -0.04)))
	match style:
		"franja":
			root.add_child(LowPoly.box(Vector3(0.5, 0.1, 0.07), hair, Vector3(0, 1.44, 0.235)))
			root.add_child(LowPoly.box(Vector3(0.22, 0.07, 0.07), hair, Vector3(-0.1, 1.38, 0.235)))
		"rabo":
			# franja de lado e mechas que emolduram o rosto
			root.add_child(LowPoly.box(Vector3(0.5, 0.1, 0.07), hair, Vector3(0, 1.44, 0.235)))
			root.add_child(LowPoly.box(Vector3(0.2, 0.1, 0.07), hair, Vector3(0.14, 1.36, 0.235)))
			for side in [-1.0, 1.0]:
				root.add_child(LowPoly.box(Vector3(0.06, 0.3, 0.12), hair, Vector3(side * 0.245, 1.27, 0.1)))
			root.add_child(LowPoly.box(Vector3(0.14, 0.14, 0.14), hair, Vector3(0, 1.43, -0.3)))
			root.add_child(LowPoly.box(Vector3(0.12, 0.3, 0.12), hair, Vector3(0, 1.22, -0.34)))
			root.add_child(LowPoly.box(Vector3(0.16, 0.05, 0.16), "vermelho", Vector3(0, 1.37, -0.31)))
		"trancas":
			for side in [-1.0, 1.0]:
				root.add_child(LowPoly.box(Vector3(0.1, 0.5, 0.1), hair, Vector3(side * 0.27, 1.12, 0.0)))
				root.add_child(LowPoly.box(Vector3(0.11, 0.05, 0.11), "vermelho", Vector3(side * 0.27, 0.9, 0.0)))
		"volume":
			root.add_child(LowPoly.box(Vector3(0.62, 0.22, 0.6), hair, Vector3(0, 1.57, -0.02)))
			root.add_child(LowPoly.box(Vector3(0.56, 0.3, 0.14), hair, Vector3(0, 1.4, -0.26)))
		_:
			root.add_child(LowPoly.box(Vector3(0.46, 0.07, 0.07), hair, Vector3(0, 1.45, 0.235)))
