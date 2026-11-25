class_name Figures
extends RefCounted
## Personagens históricos de José (Egito) e Daniel (Babilônia). Origem nos pés, frente para +Z, 1 unidade = 1 metro.
## Cerca de 3,6 cabeças de altura. Membros, tronco e cabeça são troncos afunilados de faces planas (nada de cubos
## puros); roupas e acessórios vêm por função. Simplificações inspiradas no período, sem arma em destaque.

const HEIGHT := 1.64


static func _fr(parent: Node3D, base: Vector2, top: Vector2, h: float, color: String, pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO, offset: Vector2 = Vector2.ZERO) -> void:
	parent.add_child(LowPoly.frustum(base, top, h, color, pos, rot, offset))


static func _bx(parent: Node3D, size: Vector3, color: String, pos: Vector3, rot: Vector3 = Vector3.ZERO) -> void:
	parent.add_child(LowPoly.box(size, color, pos, rot))


## Opções: skin, hair, hair_style (curto, peruca, cachos, pano, chapeu, calvo), beard ("", curta, cachos, longa), mood,
## outfit (tunica, tunica_longa, saiote, saiote_longo, robe), hem, main, trim, sash, cape, collar, items, height, girth.
static func build(o: Dictionary = {}) -> Node3D:
	var skin: String = o.get("skin", "pele_3")
	var root := Node3D.new()
	root.name = o.get("name", "Figura")
	_body(root, skin)
	_head(root, skin, o)
	_outfit(root, skin, o)
	for item in o.get("items", []):
		_item(root, item)
	root.scale = Vector3(o.get("girth", 1.0), o.get("height", 1.0), o.get("girth", 1.0))
	return root


## Só a cabeça (estudos de expressão). Origem na base do pescoço, deslocada para y = 0.
static func build_head(o: Dictionary = {}) -> Node3D:
	var root := Node3D.new()
	_head(root, o.get("skin", "pele_3"), o)
	root.position.y = -1.18
	var holder := Node3D.new()
	holder.add_child(root)
	return holder


static func _body(root: Node3D, skin: String) -> void:
	for side in [-1.0, 1.0]:
		var x: float = side * 0.1
		_fr(root, Vector2(0.1, 0.1), Vector2(0.13, 0.13), 0.28, skin, Vector3(x, 0.04, 0.0)) # canela
		_fr(root, Vector2(0.13, 0.13), Vector2(0.16, 0.16), 0.3, skin, Vector3(x, 0.32, 0.0)) # coxa
		_fr(root, Vector2(0.12, 0.26), Vector2(0.11, 0.21), 0.04, "marrom_escuro", Vector3(x, 0.0, 0.03)) # sandália
		_bx(root, Vector3(0.1, 0.02, 0.02), "marrom", Vector3(x, 0.07, 0.07))
		_fr(root, Vector2(0.095, 0.095), Vector2(0.125, 0.125), 0.28, skin, Vector3(side * 0.28, 0.82, 0.0)) # braço
		_fr(root, Vector2(0.08, 0.08), Vector2(0.095, 0.095), 0.25, skin, Vector3(side * 0.28, 0.57, 0.0)) # antebraço
		_fr(root, Vector2(0.075, 0.06), Vector2(0.09, 0.07), 0.09, skin, Vector3(side * 0.28, 0.48, 0.0)) # mão
	_fr(root, Vector2(0.28, 0.19), Vector2(0.46, 0.24), 0.48, skin, Vector3(0, 0.62, 0)) # tronco: cintura estreita, ombros largos
	_fr(root, Vector2(0.13, 0.13), Vector2(0.12, 0.12), 0.09, skin, Vector3(0, 1.1, 0)) # pescoço


static func _head(root: Node3D, skin: String, o: Dictionary) -> void:
	var hair: String = o.get("hair", "cabelo_preto")
	_fr(root, Vector2(0.27, 0.29), Vector2(0.4, 0.4), 0.4, skin, Vector3(0, 1.18, 0)) # cabeça: mais larga em cima, queixo estreito
	_fr(root, Vector2(0.4, 0.4), Vector2(0.3, 0.29), 0.06, skin, Vector3(0, 1.58, 0)) # calota: arredonda o alto da cabeça
	for side in [-1.0, 1.0]:
		_bx(root, Vector3(0.03, 0.08, 0.05), skin, Vector3(side * 0.205, 1.4, 0.0))
		_bx(root, Vector3(0.055, 0.07, 0.02), "tinta", Vector3(side * 0.09, 1.46, 0.19)) # olho
		_bx(root, Vector3(0.028, 0.028, 0.015), "espuma", Vector3(side * 0.09 + side * 0.012, 1.48, 0.2))
	_fr(root, Vector2(0.05, 0.05), Vector2(0.04, 0.04), 0.08, skin, Vector3(0, 1.31, 0.19)) # nariz
	var mood: String = o.get("mood", "sereno")
	var tilt := 0.0
	match mood:
		"sorriso":
			_bx(root, Vector3(0.1, 0.022, 0.02), "tinta", Vector3(0, 1.3, 0.178))
			for side in [-1.0, 1.0]:
				_bx(root, Vector3(0.025, 0.03, 0.02), "tinta", Vector3(side * 0.065, 1.325, 0.178))
		"determinado":
			tilt = 12.0
			_bx(root, Vector3(0.085, 0.02, 0.02), "tinta", Vector3(0, 1.3, 0.178))
		"surpreso":
			tilt = -8.0
			_bx(root, Vector3(0.045, 0.055, 0.02), "tinta", Vector3(0, 1.3, 0.178))
		_:
			_bx(root, Vector3(0.09, 0.02, 0.02), "tinta", Vector3(0, 1.3, 0.178))
	for side in [-1.0, 1.0]:
		_bx(root, Vector3(0.1, 0.024, 0.02), hair, Vector3(side * 0.09, 1.54, 0.19), Vector3(0, 0, side * tilt))
	_hair(root, hair, o.get("hair_style", "curto"), o)
	_beard(root, hair, o.get("beard", ""))


static func _hair(root: Node3D, hair: String, style: String, o: Dictionary) -> void:
	var trim: String = o.get("trim", "dourado_antigo")
	var main: String = o.get("hat", o.get("main", "linho")) # pano e chapéu podem ter cor própria
	match style:
		"calvo":
			pass
		"peruca":
			_fr(root, Vector2(0.45, 0.45), Vector2(0.42, 0.42), 0.12, hair, Vector3(0, 1.56, 0))
			_fr(root, Vector2(0.54, 0.14), Vector2(0.46, 0.16), 0.52, hair, Vector3(0, 1.12, -0.2))
			for side in [-1.0, 1.0]:
				_fr(root, Vector2(0.1, 0.3), Vector2(0.09, 0.28), 0.5, hair, Vector3(side * 0.245, 1.12, 0.0))
			_bx(root, Vector3(0.42, 0.07, 0.05), hair, Vector3(0, 1.57, 0.2))
			_bx(root, Vector3(0.45, 0.02, 0.06), trim, Vector3(0, 1.5, 0.2))
		"cachos":
			_fr(root, Vector2(0.43, 0.43), Vector2(0.41, 0.4), 0.1, hair, Vector3(0, 1.57, 0))
			for row in 3:
				for i in 5:
					_bx(root, Vector3(0.075, 0.075, 0.075), hair, Vector3(-0.15 + i * 0.075, 1.5 - row * 0.085, -0.2), Vector3(0, 0, 45))
			for side in [-1.0, 1.0]:
				_bx(root, Vector3(0.07, 0.07, 0.07), hair, Vector3(side * 0.21, 1.47, -0.1), Vector3(0, 0, 45))
		"pano":
			_fr(root, Vector2(0.46, 0.46), Vector2(0.42, 0.42), 0.17, main, Vector3(0, 1.52, 0))
			_fr(root, Vector2(0.465, 0.465), Vector2(0.462, 0.462), 0.035, trim, Vector3(0, 1.52, 0))
			for side in [-1.0, 1.0]:
				_fr(root, Vector2(0.09, 0.1), Vector2(0.1, 0.12), 0.3, main, Vector3(side * 0.225, 1.25, -0.02))
			_fr(root, Vector2(0.4, 0.07), Vector2(0.42, 0.09), 0.3, main, Vector3(0, 1.28, -0.22))
		"chapeu":
			_fr(root, Vector2(0.45, 0.45), Vector2(0.4, 0.4), 0.22, main, Vector3(0, 1.58, 0))
			_fr(root, Vector2(0.455, 0.455), Vector2(0.45, 0.45), 0.05, trim, Vector3(0, 1.58, 0))
			_fr(root, Vector2(0.28, 0.28), Vector2(0.2, 0.2), 0.04, trim, Vector3(0, 1.8, 0))
		_:
			_fr(root, Vector2(0.43, 0.43), Vector2(0.4, 0.38), 0.1, hair, Vector3(0, 1.57, 0))
			_fr(root, Vector2(0.4, 0.1), Vector2(0.37, 0.1), 0.3, hair, Vector3(0, 1.34, -0.18))
			for side in [-1.0, 1.0]:
				_fr(root, Vector2(0.045, 0.22), Vector2(0.04, 0.2), 0.2, hair, Vector3(side * 0.205, 1.4, -0.02))
			_bx(root, Vector3(0.38, 0.05, 0.04), hair, Vector3(0, 1.56, 0.2))


static func _beard(root: Node3D, hair: String, beard: String) -> void:
	match beard:
		"curta":
			_fr(root, Vector2(0.3, 0.16), Vector2(0.32, 0.18), 0.13, hair, Vector3(0, 1.17, 0.07))
			_bx(root, Vector3(0.15, 0.03, 0.03), hair, Vector3(0, 1.345, 0.185))
		"cachos":
			_bx(root, Vector3(0.15, 0.03, 0.03), hair, Vector3(0, 1.345, 0.185))
			for row in 3:
				for i in 3:
					_bx(root, Vector3(0.07, 0.07, 0.07), hair, Vector3((i - 1) * 0.08, 1.2 - row * 0.075, 0.17), Vector3(0, 0, 45))
		"longa":
			_fr(root, Vector2(0.2, 0.14), Vector2(0.3, 0.17), 0.34, hair, Vector3(0, 0.86, 0.08))
			_bx(root, Vector3(0.16, 0.03, 0.03), hair, Vector3(0, 1.345, 0.185))


static func _outfit(root: Node3D, skin: String, o: Dictionary) -> void:
	var main: String = o.get("main", "linho")
	var trim: String = o.get("trim", "dourado_trigo")
	var sash: String = o.get("sash", "marrom_escuro")
	var hem: float = o.get("hem", 0.34)
	match o.get("outfit", "tunica"):
		"saiote", "saiote_longo":
			var long: bool = o.get("outfit") == "saiote_longo"
			var bottom: float = 0.2 if long else 0.34
			_fr(root, Vector2(0.54, 0.36), Vector2(0.34, 0.24), 0.64 - bottom, main, Vector3(0, bottom, 0))
			_fr(root, Vector2(0.35, 0.25), Vector2(0.35, 0.25), 0.07, trim, Vector3(0, 0.62, 0))
			root.add_child(LowPoly.prism(3, 0.12, 0.12, 0.03, trim, Vector3(0, bottom + 0.14, 0.165), Vector3(90, 0, 0), 30.0))
			if o.get("strap", false):
				_bx(root, Vector3(0.6, 0.05, 0.03), "marrom", Vector3(0, 0.9, 0.125), Vector3(0, 0, -35))
		"tunica_longa", "tunica", "robe":
			var robe: bool = o.get("outfit") == "robe"
			var bottom: float = 0.1 if (robe or o.get("outfit") == "tunica_longa") else hem
			var flare: float = 0.74 if robe else (0.64 if bottom < 0.2 else 0.56)
			_fr(root, Vector2(0.38, 0.25), Vector2(0.48, 0.27), 0.5, main, Vector3(0, 0.6, 0)) # busto
			_fr(root, Vector2(flare, flare * 0.6), Vector2(0.38, 0.25), 0.6 - bottom, main, Vector3(0, bottom, 0)) # saia em A
			_fr(root, Vector2(flare + 0.01, flare * 0.6 + 0.01), Vector2(flare, flare * 0.6), 0.06, trim, Vector3(0, bottom, 0)) # barra
			_fr(root, Vector2(0.4, 0.27), Vector2(0.4, 0.27), 0.07, sash, Vector3(0, 0.58, 0))
			_bx(root, Vector3(0.06, 0.12, 0.04), sash, Vector3(0.17, 0.5, 0.15))
			for side in [-1.0, 1.0]:
				var sleeve_h: float = 0.5 if robe else 0.24
				var y: float = 1.1 - sleeve_h
				_fr(root, Vector2(0.14, 0.14), Vector2(0.17, 0.17), sleeve_h, main, Vector3(side * 0.28, y, 0.0))
				_fr(root, Vector2(0.142, 0.142), Vector2(0.145, 0.145), 0.035, trim, Vector3(side * 0.28, y, 0.0))
			if robe:
				_bx(root, Vector3(0.1, 0.8, 0.02), trim, Vector3(0, 0.5, 0.225), Vector3(-6, 0, 0))
				for i in 13:
					var fx := -0.3 + i * 0.05
					_bx(root, Vector3(0.03, 0.07, 0.02), trim if i % 2 == 0 else "creme", Vector3(fx, 0.07, 0.225))
					_bx(root, Vector3(0.03, 0.07, 0.02), trim if i % 2 == 0 else "creme", Vector3(fx, 0.07, -0.225))
			else:
				_bx(root, Vector3(0.03, 0.22, 0.02), trim, Vector3(-0.05, 0.98, 0.14), Vector3(0, 0, 22))
				_bx(root, Vector3(0.03, 0.22, 0.02), trim, Vector3(0.05, 0.98, 0.14), Vector3(0, 0, -22))
	if o.get("cape", "") != "":
		var cape: String = o.get("cape")
		_fr(root, Vector2(0.62, 0.1), Vector2(0.52, 0.1), 0.86, cape, Vector3(0, 0.26, -0.17))
		_bx(root, Vector3(0.6, 0.07, 0.03), cape, Vector3(0, 0.95, 0.135), Vector3(0, 0, -30))
		_bx(root, Vector3(0.06, 0.06, 0.03), trim, Vector3(0.18, 1.03, 0.14))
	if o.get("collar", false):
		root.add_child(LowPoly.prism(8, 0.28, 0.17, 0.05, "azul_nilo", Vector3(0, 1.04, 0)))
		root.add_child(LowPoly.prism(8, 0.23, 0.13, 0.04, "dourado_trigo", Vector3(0, 1.07, 0)))
		root.add_child(LowPoly.prism(8, 0.17, 0.1, 0.03, "azul_nilo", Vector3(0, 1.1, 0)))


static func _item(root: Node3D, item: String) -> void:
	match item:
		"cajado":
			_fr(root, Vector2(0.04, 0.04), Vector2(0.05, 0.05), 1.5, "marrom", Vector3(0.36, 0.0, 0.1))
			root.add_child(LowPoly.prism(6, 0.05, 0.05, 0.08, "dourado_antigo", Vector3(0.36, 1.5, 0.1)))
		"cajado_cerimonial":
			_fr(root, Vector2(0.04, 0.04), Vector2(0.05, 0.05), 1.7, "marrom_escuro", Vector3(0.36, 0.0, 0.1))
			root.add_child(LowPoly.prism(8, 0.08, 0.08, 0.12, "dourado_antigo", Vector3(0.36, 1.7, 0.1)))
			_fr(root, Vector2(0.14, 0.14), Vector2(0.08, 0.08), 0.1, "azul_lapis", Vector3(0.36, 1.82, 0.1))
		"bolsa":
			_fr(root, Vector2(0.22, 0.1), Vector2(0.2, 0.09), 0.18, "marrom", Vector3(-0.32, 0.4, 0.04))
			_fr(root, Vector2(0.23, 0.11), Vector2(0.23, 0.11), 0.05, "marrom_escuro", Vector3(-0.32, 0.55, 0.04))
			_bx(root, Vector3(0.035, 0.82, 0.02), "marrom_escuro", Vector3(-0.02, 0.84, 0.13), Vector3(0, 0, 38))
		"tabuleta":
			_fr(root, Vector2(0.16, 0.03), Vector2(0.15, 0.03), 0.22, "adobe", Vector3(-0.3, 0.46, 0.12), Vector3(20, 0, 0))
			_bx(root, Vector3(0.1, 0.012, 0.012), "terracota", Vector3(-0.3, 0.55, 0.14), Vector3(20, 0, 0))
			_bx(root, Vector3(0.1, 0.012, 0.012), "terracota", Vector3(-0.3, 0.6, 0.15), Vector3(20, 0, 0))
		"rolo":
			root.add_child(LowPoly.prism(8, 0.035, 0.035, 0.3, "linho", Vector3(-0.3, 0.42, 0.1), Vector3(0, 0, 0)))
			root.add_child(LowPoly.prism(8, 0.045, 0.045, 0.03, "marrom_escuro", Vector3(-0.3, 0.42, 0.1)))
			root.add_child(LowPoly.prism(8, 0.045, 0.045, 0.03, "marrom_escuro", Vector3(-0.3, 0.69, 0.1)))
		"cesto":
			_fr(root, Vector2(0.26, 0.26), Vector2(0.38, 0.38), 0.24, "dourado_trigo", Vector3(0, 0.46, 0.32))
			_fr(root, Vector2(0.325, 0.325), Vector2(0.345, 0.345), 0.03, "ocre", Vector3(0, 0.55, 0.32))
			for i in 3:
				root.add_child(LowPoly.pyramid(4, 0.06, 0.24, "dourado_trigo", Vector3((i - 1) * 0.1, 0.7, 0.32), Vector3(0, i * 25, (i - 1) * 8)))
		"jarro":
			_fr(root, Vector2(0.14, 0.14), Vector2(0.26, 0.26), 0.24, "terracota", Vector3(-0.33, 0.3, 0.1))
			root.add_child(LowPoly.prism(6, 0.07, 0.06, 0.1, "terracota", Vector3(-0.33, 0.54, 0.1)))
			_fr(root, Vector2(0.14, 0.14), Vector2(0.14, 0.14), 0.04, "ocre", Vector3(-0.33, 0.5, 0.1))
		"medalhao":
			root.add_child(LowPoly.prism(8, 0.055, 0.055, 0.018, "dourado_trigo", Vector3(0, 0.88, 0.15), Vector3(90, 0, 0)))
			_bx(root, Vector3(0.02, 0.2, 0.012), "dourado_trigo", Vector3(-0.07, 0.99, 0.135), Vector3(0, 0, -30))
			_bx(root, Vector3(0.02, 0.2, 0.012), "dourado_trigo", Vector3(0.07, 0.99, 0.135), Vector3(0, 0, 30))
