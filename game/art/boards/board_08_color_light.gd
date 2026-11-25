class_name Board08ColorLight
extends RefCounted
## Prancha 8: Color & Lighting. A paleta completa e a mesma cena sob quatro luzes: o material nunca muda, só a luz.

const CHIP := Vector2(240, 104)
const CELL := Vector2(280, 188)


static func build() -> Node:
	var root := Node.new()
	var layer := CanvasLayer.new()
	root.add_child(layer)
	var background := ColorRect.new()
	background.color = Palette.color("cinza_claro")
	background.size = Vector2(BoardFrame.SIZE)
	layer.add_child(background)

	# Paleta
	var groups := [
		["REFERÊNCIA DO GUIA", Palette.REFERENCE],
		["COMPLEMENTARES (PROPOSTAS)", ["amarelo_lenco", "azul_ceu", "creme", "azul_agua", "espuma", "verde_folha", "verde_claro", "marrom_escuro", "cinza_pedra", "cinza_grafite", "laranja_fogo", "amarelo_brasa", "noite", "rosa_flor", "azul_flor", "tinta", "rosa_bochecha"]],
		["TONS DE PELE", Palette.SKINS],
		["CABELOS", Palette.HAIRS],
	]
	var y := 215.0
	for group in groups:
		UiKit.label(layer, group[0], Vector2(100, y), 50, "marrom_escuro")
		y += 78.0
		var names: Array = group[1]
		for i in names.size():
			_chip(layer, names[i], Vector2(100 + (i % 5) * CELL.x, y + (i / 5) * CELL.y))
		y += ceili(names.size() / 5.0) * CELL.y + 28.0

	# A mesma cena em quatro luzes
	var moods := [
		["MANHÃ", Stage.Mood.MANHA, ""],
		["MEIO-DIA", Stage.Mood.MEIO_DIA, ""],
		["FIM DE TARDE", Stage.Mood.TARDE, ""],
		["ESTÚDIO · FICHAS", Stage.Mood.ESTUDIO, "cinza_claro"],
	]
	var size := Vector2(1050, 905)
	for i in moods.size():
		var pos := Vector2(1680 + (i % 2) * (size.x + 40), 215 + (i / 2) * (size.y + 40))
		_scene(layer, pos, size, moods[i][1], moods[i][2], moods[i][0])
	root.add_child(BoardFrame.build(8, "Color & Lighting", "paleta · mesma cena, quatro luzes"))
	return root


static func _chip(parent: Node, color_name: String, pos: Vector2) -> void:
	var swatch := ColorRect.new()
	swatch.color = Palette.color(color_name)
	swatch.position = pos
	swatch.size = CHIP
	parent.add_child(swatch)
	var outline := Panel.new()
	outline.position = pos
	outline.size = CHIP
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0, 0, 0, 0)
	box.border_color = Palette.color("cinza_pedra")
	box.set_border_width_all(3)
	outline.add_theme_stylebox_override("panel", box)
	parent.add_child(outline)
	UiKit.label(parent, Palette.display_name(color_name), pos + Vector2(0, CHIP.y + 4), 32, "cinza_grafite")
	UiKit.label(parent, "#" + Palette.color(color_name).to_html(false).to_upper(), pos + Vector2(0, CHIP.y + 40), 30, "cinza_pedra")


static func _scene(parent: Node, pos: Vector2, size: Vector2, mood: Stage.Mood, background: String, title: String) -> void:
	var container := SubViewportContainer.new()
	container.position = pos
	container.size = size
	container.stretch = true
	var viewport := SubViewport.new()
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.size = Vector2i(size)
	container.add_child(viewport)
	viewport.add_child(MiniCamp.build(mood, background))
	parent.add_child(container)
	UiKit.panel(parent, Rect2(pos, size), "bege", "marrom_escuro", 8, 10, 0.0)
	UiKit.panel(parent, Rect2(pos + Vector2(24, 24), Vector2(430, 84)), "bege", "marrom", 6, 42, 0.92)
	UiKit.label(parent, title, pos + Vector2(24, 40), 44, "marrom_escuro", 430, HORIZONTAL_ALIGNMENT_CENTER)
