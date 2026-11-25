class_name Board07Ui
extends RefCounted
## Prancha 7: UI Design. Menu em forma de diário de expedição, mapa com objetivos, inventário e HUD sobre a cena do jogo.


static func build() -> Node:
	var root := Node.new()
	var layer := CanvasLayer.new()
	root.add_child(layer)
	var background := ColorRect.new()
	background.color = Palette.color("cinza_claro")
	background.size = Vector2(BoardFrame.SIZE)
	layer.add_child(background)
	_menu(layer, Rect2(110, 230, 1160, 1830))
	_map(layer, Rect2(1340, 230, 1160, 1830))
	_inventory_hud(layer, Rect2(2570, 230, 1160, 1830))
	root.add_child(BoardFrame.build(7, "UI Design", "diário · mapa · inventário · HUD"))
	return root


# Menu: capa de diário de couro, com espiral, costura, fita marcadora e botões de etiqueta
static func _menu(parent: Node, rect: Rect2) -> void:
	UiKit.panel(parent, rect, "marrom_escuro", "marrom", 14, 40)
	UiDraw.make(parent, Rect2(rect.position + Vector2(-50, 0), Vector2(110, rect.size.y)), func(d: Control) -> void:
		for i in 10:
			d.draw_rect(Rect2(Vector2(0, 110 + i * 170), Vector2(110, 54)), Palette.color("bege"))
			d.draw_rect(Rect2(Vector2(0, 110 + i * 170 + 54), Vector2(110, 8)), Palette.color("cinza_pedra")))
	UiDraw.make(parent, rect, func(d: Control) -> void:
		var inset := 56.0
		var r := Rect2(Vector2(inset, inset), d.size - Vector2(inset, inset) * 2.0)
		var color := Color(Palette.color("bege"), 0.6)
		d.draw_dashed_line(r.position, r.position + Vector2(r.size.x, 0), color, 6, 30)
		d.draw_dashed_line(r.position + Vector2(r.size.x, 0), r.end, color, 6, 30)
		d.draw_dashed_line(r.end, r.position + Vector2(0, r.size.y), color, 6, 30)
		d.draw_dashed_line(r.position + Vector2(0, r.size.y), r.position, color, 6, 30)
		# fita marcadora
		d.draw_colored_polygon(PackedVector2Array([Vector2(d.size.x - 250, 0), Vector2(d.size.x - 150, 0), Vector2(d.size.x - 150, 290), Vector2(d.size.x - 200, 240), Vector2(d.size.x - 250, 290)]), Palette.color("vermelho")))
	UiKit.label(parent, "ALÉM DA JORNADA", rect.position + Vector2(100, 130), 100, "bege", rect.size.x - 200, HORIZONTAL_ALIGNMENT_CENTER)
	UiKit.label(parent, "Diário de expedição", rect.position + Vector2(100, 270), 58, "creme", rect.size.x - 200, HORIZONTAL_ALIGNMENT_CENTER)
	UiDraw.make(parent, rect, func(d: Control) -> void:
		UiKit.icon(d, "bussola", Vector2(d.size.x / 2.0, 640), 190))
	var labels := ["Continuar jornada", "Nova jornada", "Minha equipe", "Opções"]
	for i in labels.size():
		UiKit.button(parent, labels[i], Rect2(rect.position + Vector2(180, 960 + i * 175), Vector2(rect.size.x - 360, 140)), 58)
	UiKit.label(parent, "Desbravadores · versão 0.1", rect.position + Vector2(100, rect.size.y - 175), 40, "creme", rect.size.x - 200, HORIZONTAL_ALIGNMENT_CENTER)


# Mapa ilustrado e lista de objetivos
static func _map(parent: Node, rect: Rect2) -> void:
	UiKit.panel(parent, rect, "bege", "marrom", 12, 32)
	UiKit.label(parent, "MAPA E OBJETIVOS", rect.position + Vector2(60, 50), 76, "marrom_escuro")
	var map_rect := Rect2(rect.position + Vector2(60, 190), Vector2(rect.size.x - 120, 960))
	UiKit.panel(parent, map_rect, "creme", "marrom_escuro", 8, 14)
	UiDraw.make(parent, map_rect, func(d: Control) -> void:
		var w := d.size.x
		var h := d.size.y
		d.draw_rect(Rect2(20, 20, w - 40, h - 40), Palette.color("verde_claro"))
		d.draw_colored_polygon(PackedVector2Array([Vector2(w * 0.28, h * 0.5), Vector2(w * 0.5, h * 0.42), Vector2(w * 0.62, h * 0.6), Vector2(w * 0.4, h * 0.74), Vector2(w * 0.24, h * 0.66)]), Palette.color("bege"))
		# montanhas
		for m in [[0.2, 0.2, 130.0], [0.5, 0.16, 170.0], [0.78, 0.22, 140.0]]:
			var c := Vector2(w * m[0], h * m[1] + 60)
			var s: float = m[2]
			d.draw_colored_polygon(PackedVector2Array([c + Vector2(-s, 0), c + Vector2(0, -s * 1.1), c + Vector2(s, 0)]), Palette.color("cinza_pedra"))
			d.draw_colored_polygon(PackedVector2Array([c + Vector2(-s * 0.36, -s * 0.7), c + Vector2(0, -s * 1.1), c + Vector2(s * 0.36, -s * 0.7)]), Palette.color("cinza_claro"))
		# rio
		var river := PackedVector2Array([Vector2(40, h * 0.34), Vector2(w * 0.25, h * 0.3), Vector2(w * 0.45, h * 0.36), Vector2(w * 0.7, h * 0.32), Vector2(w - 40, h * 0.38)])
		d.draw_polyline(river, Palette.color("azul_agua"), 78)
		d.draw_polyline(river, Palette.color("espuma"), 8)
		d.draw_rect(Rect2(w * 0.42, h * 0.3, 70, 130), Palette.color("marrom"))
		# árvores
		for t in [[0.1, 0.55], [0.16, 0.7], [0.08, 0.84], [0.74, 0.6], [0.84, 0.72], [0.9, 0.58], [0.72, 0.84], [0.56, 0.86], [0.3, 0.86], [0.92, 0.82]]:
			var p := Vector2(w * t[0], h * t[1])
			d.draw_colored_polygon(PackedVector2Array([p + Vector2(-34, 38), p + Vector2(0, -44), p + Vector2(34, 38)]), Palette.color("verde_floresta"))
		# acampamento: barraca e fogueira
		var camp := Vector2(w * 0.42, h * 0.6)
		d.draw_colored_polygon(PackedVector2Array([camp + Vector2(-56, 40), camp + Vector2(0, -50), camp + Vector2(56, 40)]), Palette.color("bege"))
		d.draw_colored_polygon(PackedVector2Array([camp + Vector2(-20, 40), camp + Vector2(0, -6), camp + Vector2(20, 40)]), Palette.color("marrom_escuro"))
		d.draw_colored_polygon(PackedVector2Array([camp + Vector2(40, 40), camp + Vector2(58, 0), camp + Vector2(76, 40)]), Palette.color("laranja_fogo"))
		# rota e destino
		var route := PackedVector2Array([camp + Vector2(0, 50), Vector2(w * 0.44, h * 0.5), Vector2(w * 0.46, h * 0.36), Vector2(w * 0.58, h * 0.2), Vector2(w * 0.7, h * 0.12)])
		d.draw_polyline(route, Palette.color("vermelho"), 12)
		var x := Vector2(w * 0.7, h * 0.12)
		d.draw_line(x + Vector2(-26, -26), x + Vector2(26, 26), Palette.color("vermelho"), 14)
		d.draw_line(x + Vector2(-26, 26), x + Vector2(26, -26), Palette.color("vermelho"), 14)
		# rosa dos ventos
		var rose := Vector2(w - 110, h - 110)
		d.draw_colored_polygon(UiKit.octagon(rose, 70), Palette.color("marrom_escuro"))
		d.draw_colored_polygon(UiKit.octagon(rose, 56), Palette.color("bege"))
		d.draw_colored_polygon(PackedVector2Array([rose + Vector2(0, -50), rose + Vector2(14, 0), rose + Vector2(-14, 0)]), Palette.color("vermelho"))
		d.draw_colored_polygon(PackedVector2Array([rose + Vector2(0, 50), rose + Vector2(14, 0), rose + Vector2(-14, 0)]), Palette.color("cinza_pedra")))
	UiKit.label(parent, "OBJETIVOS", rect.position + Vector2(60, 1190), 64, "marrom_escuro")
	var goals := [["check", "Montar o acampamento"], ["check", "Atravessar a ponte"], ["vazio", "Coletar os cestos de grãos (1/3)"]]
	for i in goals.size():
		var y := 1290 + i * 112
		var kind: String = goals[i][0]
		UiDraw.make(parent, Rect2(rect.position + Vector2(60, y), Vector2(80, 80)), func(d: Control) -> void: UiKit.icon(d, kind, Vector2(40, 40), 38))
		UiKit.label(parent, goals[i][1], rect.position + Vector2(170, y + 6), 52, "marrom_escuro")
	# indicador do objetivo atual
	UiKit.panel(parent, Rect2(rect.position + Vector2(60, 1650), Vector2(rect.size.x - 120, 130)), "amarelo_lenco", "vermelho", 8, 66)
	UiDraw.make(parent, Rect2(rect.position + Vector2(100, 1672), Vector2(90, 90)), func(d: Control) -> void: UiKit.icon(d, "bandeira", Vector2(45, 45), 42))
	UiKit.label(parent, "OBJETIVO ATUAL: coletar os cestos", rect.position + Vector2(210, 1690), 50, "marrom_escuro")


# Inventário em grade e HUD sobre a cena do jogo
static func _inventory_hud(parent: Node, rect: Rect2) -> void:
	UiKit.panel(parent, rect, "bege", "marrom", 12, 32)
	UiKit.label(parent, "INVENTÁRIO E HUD", rect.position + Vector2(60, 50), 76, "marrom_escuro")
	var frame := Rect2(rect.position + Vector2(60, 190), Vector2(rect.size.x - 120, 620))
	UiKit.panel(parent, frame, "creme", "marrom_escuro", 8, 14)
	var kinds := ["mochila", "bussola", "mapa", "corda", "lanterna", "cantil", "caixa", "bandeira"]
	var slot := 230.0
	var gap := 30.0
	var start := frame.position + Vector2((frame.size.x - (4 * slot + 3 * gap)) / 2.0, 40)
	for i in 8:
		var origin := start + Vector2((i % 4) * (slot + gap), (i / 4) * (slot + gap))
		var selected := i == 1
		UiKit.panel(parent, Rect2(origin, Vector2(slot, slot)), "bege", "amarelo_lenco" if selected else "marrom", 16 if selected else 8, 18)
		var kind: String = kinds[i]
		UiDraw.make(parent, Rect2(origin, Vector2(slot, slot)), func(d: Control) -> void: UiKit.icon(d, kind, d.size / 2.0, 78))
	UiKit.label(parent, "Mochila: 8 de 12 espaços", frame.position + Vector2(40, frame.size.y - 80), 46, "marrom_escuro")

	UiKit.label(parent, "HUD EM JOGO", rect.position + Vector2(60, 850), 62, "marrom_escuro")
	var hud := Rect2(rect.position + Vector2(60, 940), Vector2(rect.size.x - 120, 820))
	var container := SubViewportContainer.new()
	container.position = hud.position
	container.size = hud.size
	container.stretch = true
	var viewport := SubViewport.new()
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.size = Vector2i(hud.size)
	container.add_child(viewport)
	viewport.add_child(MiniCamp.build(Stage.Mood.MANHA))
	parent.add_child(container)
	UiKit.panel(parent, hud, "bege", "marrom_escuro", 8, 14, 0.0)
	# objetivo (canto superior esquerdo)
	UiKit.panel(parent, Rect2(hud.position + Vector2(30, 30), Vector2(520, 110)), "bege", "marrom", 8, 55, 0.92)
	UiDraw.make(parent, Rect2(hud.position + Vector2(56, 50), Vector2(70, 70)), func(d: Control) -> void: UiKit.icon(d, "bandeira", Vector2(35, 35), 32))
	UiKit.label(parent, "Cestos 1/3", hud.position + Vector2(150, 52), 50, "marrom_escuro")
	# bússola (canto superior direito)
	UiDraw.make(parent, Rect2(hud.position + Vector2(hud.size.x - 150, 20), Vector2(130, 130)), func(d: Control) -> void: UiKit.icon(d, "bussola", Vector2(65, 65), 58))
	# equipe (canto inferior esquerdo)
	for i in 3:
		UiDraw.make(parent, Rect2(hud.position + Vector2(40 + i * 120, hud.size.y - 140), Vector2(110, 110)), func(d: Control) -> void: UiKit.icon(d, "rosto", Vector2(55, 55), 50))
	# botão de interação (canto inferior direito), igual ao dos controles de toque
	UiDraw.make(parent, Rect2(hud.position + Vector2(hud.size.x - 210, hud.size.y - 210), Vector2(180, 180)), func(d: Control) -> void:
		d.draw_circle(Vector2(90, 90), 84, Color(Palette.color("noite"), 0.55))
		d.draw_arc(Vector2(90, 90), 84, 0.0, TAU, 40, Palette.color("cinza_claro"), 6.0))
	UiKit.label(parent, "Interagir", hud.position + Vector2(hud.size.x - 210, hud.size.y - 142), 32, "cinza_claro", 180, HORIZONTAL_ALIGNMENT_CENTER)
