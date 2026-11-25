extends RefCounted
## Consistência visual (docs/art/direcao-de-arte.md, seção 9), verificada por código: cores só da paleta, materiais foscos
## e sem textura, só geometria do kit, orçamento de triângulos e cabeçalho e luz iguais em todas as pranchas.

const CHARACTER_BUDGET := 2000
const TREE_BUDGET := 400
const OBJECT_BUDGET := 300
const EFFECT_BUDGET := 600


func test_paleta_tem_as_cinco_cores_do_guia() -> String:
	var expected := {"marrom": "B1611F", "vermelho": "77170C", "verde_floresta": "404F32", "bege": "E5DBC6", "cinza_claro": "F4F5F8"}
	for key in expected:
		var got := Palette.color(key).to_html(false).to_upper()
		if got != expected[key]:
			return "%s deveria ser #%s e é #%s" % [key, expected[key], got]
	return ""


func test_materiais_so_da_paleta_foscos_e_sem_textura() -> String:
	for entry in _models():
		var problem := _check_materials(entry[1] as Node, entry[0] as String)
		if problem != "":
			return problem
	return ""


func test_toda_geometria_vem_do_kit() -> String:
	for entry in _models():
		for mesh in _meshes(entry[1] as Node):
			if not mesh.has_meta("lowpoly"):
				return "%s tem malha que não veio do LowPoly" % entry[0]
	return ""


func test_orcamento_de_triangulos() -> String:
	for entry in _models():
		var name: String = entry[0]
		var tris := LowPoly.triangles(entry[1] as Node)
		var budget := OBJECT_BUDGET
		if name.begins_with("personagem"):
			budget = CHARACTER_BUDGET
		elif name in ["pinheiro", "arvore", "palmeira"]:
			budget = TREE_BUDGET
		elif name.begins_with("efeito"):
			budget = EFFECT_BUDGET
		if tris > budget:
			return "%s tem %d triângulos (limite %d)" % [name, tris, budget]
	return ""


func test_pranchas_usam_cabecalho_e_luz_do_kit() -> String:
	var builders := [Board01Characters.build, Board02Uniform.build, Board03Environment.build, Board04Nature.build,
		Board05Props.build, Board06Effects.build, Board07Ui.build, Board08ColorLight.build]
	for i in builders.size():
		var board: Node = builders[i].call()
		var problem := _check_board(board, i + 1)
		board.free()
		if problem != "":
			return problem
	return ""


# [nome, nó] de tudo que o kit constrói. Quem chama deve liberar com _free_models, mas o runner sai logo depois.
func _models() -> Array:
	var list: Array = []
	list.append(["personagem masculino", Characters.build({"female": false})])
	list.append(["personagem feminino", Characters.build({"female": true, "hair_style": "rabo"})])
	for style in Characters.HAIR_STYLES:
		list.append(["personagem penteado %s" % style, Characters.build({"hair_style": style})])
	var props := {"barraca": Props.tent(), "mochila": Props.backpack(), "cantil": Props.canteen(), "bota": Props.boot(),
		"lenco": Props.neckerchief(), "bussola": Props.compass(), "mapa": Props.map(), "corda": Props.rope(),
		"lanterna": Props.lantern(), "caixa": Props.crate(), "ponte": Props.bridge(), "placa": Props.sign_post(),
		"fogueira": Props.campfire()}
	for key in props:
		list.append([key, props[key]])
	var nature := {"pinheiro": Nature.pine(), "arvore": Nature.broadleaf(), "palmeira": Nature.palm(), "arbusto": Nature.bush(),
		"flores": Nature.flowers(), "capim": Nature.grass(), "pedra": Nature.rock(), "montanha": Nature.mountain(),
		"rio": Nature.river(), "cachoeira": Nature.waterfall(), "capivara": Nature.capybara(), "arara": Nature.macaw(), "veado": Nature.deer()}
	for key in nature:
		list.append([key, nature[key]])
	var fx := {"efeito agua": Fx.water(), "efeito raios de luz": Fx.light_shafts(), "efeito poeira": Fx.dust(),
		"efeito folhas": Fx.leaves(), "efeito fogo": Fx.fire(), "efeito neblina": Fx.mist_fireflies()}
	for key in fx:
		list.append([key, fx[key]])
	return list


func _meshes(root: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	if root is MeshInstance3D:
		found.append(root)
	for child in root.get_children():
		found.append_array(_meshes(child))
	return found


func _check_materials(root: Node, name: String) -> String:
	var is_effect := name.begins_with("efeito")
	for mesh in _meshes(root):
		var m := mesh.material_override as StandardMaterial3D
		if m == null:
			return "%s: malha sem material do kit" % name
		var palette_name: String = m.get_meta("palette_name", "")
		if not Palette.COLORS.has(palette_name):
			return "%s: cor fora da paleta ('%s')" % [name, palette_name]
		var expected: Color = Palette.COLORS[palette_name]
		if not Color(m.albedo_color, 1.0).is_equal_approx(expected):
			return "%s: a cor do material não é a da paleta (%s)" % [name, palette_name]
		if m.albedo_texture != null or m.normal_texture != null or m.roughness_texture != null:
			return "%s: material com textura" % name
		if m.get_meta("effect", false):
			# materiais de efeito podem ser translúcidos, mas só os efeitos usam
			if not is_effect and not _is_effect_piece(mesh):
				return "%s: material de efeito fora de um efeito" % name
		else:
			if m.roughness != 1.0 or m.metallic != 0.0 or m.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
				return "%s: material sólido que não é fosco e opaco" % name
	return ""


func _is_effect_piece(mesh: MeshInstance3D) -> bool:
	return mesh.has_meta("effect")


func _check_board(board: Node, number: int) -> String:
	# cabeçalho padrão: CanvasLayer 10 com o título "ALÉM DA JORNADA"
	var frame: CanvasLayer = null
	for child in board.get_children():
		if child is CanvasLayer and (child as CanvasLayer).layer == 10:
			frame = child
	if frame == null:
		return "prancha %d sem o cabeçalho padrão" % number
	var has_title := false
	for child in frame.get_children():
		if child is Label and (child as Label).text == "ALÉM DA JORNADA":
			has_title = true
	if not has_title:
		return "prancha %d: cabeçalho sem o título" % number
	# luz: se a prancha tem sol próprio, ele tem que ser igual a uma das situações do Stage
	for child in board.get_children():
		if child is DirectionalLight3D:
			var light := child as DirectionalLight3D
			var matches := false
			for mood in Stage.SUN:
				var spec: Dictionary = Stage.SUN[mood]
				if absf(light.light_energy - spec.energy) < 0.001 and light.light_color.is_equal_approx(spec.color) \
						and absf(light.rotation_degrees.x - spec.pitch) < 0.01:
					matches = true
			if not matches:
				return "prancha %d tem um sol que não é de nenhuma situação do Stage" % number
	return ""
