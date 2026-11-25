class_name UiKit
extends RefCounted
## Interface de diário de expedição: painéis, botões, rótulos e ícones geométricos, só com cores da Palette.
## Formas simples (retângulos, triângulos e octógonos), na mesma família dos modelos 3D. Nada militar nem futurista.


static func panel(parent: Node, rect: Rect2, fill: String, border: String, border_w: int = 10, radius: int = 28, alpha: float = 1.0) -> Panel:
	var p := Panel.new()
	p.position = rect.position
	p.size = rect.size
	var box := StyleBoxFlat.new()
	box.bg_color = Color(Palette.color(fill), alpha)
	box.border_color = Palette.color(border)
	box.set_border_width_all(border_w)
	box.set_corner_radius_all(radius)
	box.shadow_color = Color(Palette.color("noite"), 0.22)
	box.shadow_size = 16
	box.shadow_offset = Vector2(0, 10)
	p.add_theme_stylebox_override("panel", box)
	parent.add_child(p)
	return p


static func label(parent: Node, text: String, pos: Vector2, font_size: int, color_name: String, width: float = -1.0, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	if width > 0.0:
		l.size = Vector2(width, font_size * 1.4)
		l.horizontal_alignment = align
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", Palette.color(color_name))
	parent.add_child(l)
	return l


## Botão de couro claro com borda marrom e costura, como etiqueta de diário.
static func button(parent: Node, text: String, rect: Rect2, font_size: int = 60) -> Button:
	var b := Button.new()
	b.text = text
	b.position = rect.position
	b.size = rect.size
	var box := StyleBoxFlat.new()
	box.bg_color = Palette.color("bege")
	box.border_color = Palette.color("marrom")
	box.set_border_width_all(8)
	box.set_corner_radius_all(22)
	box.shadow_color = Color(Palette.color("noite"), 0.3)
	box.shadow_size = 8
	box.shadow_offset = Vector2(0, 8)
	for state in ["normal", "hover", "pressed", "focus"]:
		b.add_theme_stylebox_override(state, box)
	b.add_theme_font_size_override("font_size", font_size)
	b.add_theme_color_override("font_color", Palette.color("marrom_escuro"))
	parent.add_child(b)
	return b


static func _rect(c: CanvasItem, rect: Rect2, color_name: String) -> void:
	c.draw_rect(rect, Palette.color(color_name))


static func _poly(c: CanvasItem, points: PackedVector2Array, color_name: String) -> void:
	c.draw_colored_polygon(points, Palette.color(color_name))


static func octagon(center: Vector2, radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in 8:
		var a := TAU * (float(i) + 0.5) / 8.0
		points.append(center + Vector2(cos(a), sin(a)) * radius)
	return points


## Ícone geométrico centrado em `c`, com meia-largura `s`.
static func icon(canvas: CanvasItem, kind: String, c: Vector2, s: float) -> void:
	match kind:
		"mochila":
			_rect(canvas, Rect2(c + Vector2(-0.55, -0.5) * s, Vector2(1.1, 1.25) * s), "marrom")
			_rect(canvas, Rect2(c + Vector2(-0.6, -0.72) * s, Vector2(1.2, 0.45) * s), "marrom_escuro")
			_rect(canvas, Rect2(c + Vector2(-0.3, 0.1) * s, Vector2(0.6, 0.45) * s), "vermelho")
			_rect(canvas, Rect2(c + Vector2(-0.7, -0.98) * s, Vector2(1.4, 0.28) * s), "bege")
		"bussola":
			_poly(canvas, octagon(c, s), "marrom_escuro")
			_poly(canvas, octagon(c, s * 0.78), "bege")
			_poly(canvas, PackedVector2Array([c + Vector2(0, -0.62) * s, c + Vector2(0.14, 0) * s, c + Vector2(-0.14, 0) * s]), "vermelho")
			_poly(canvas, PackedVector2Array([c + Vector2(0, 0.62) * s, c + Vector2(0.14, 0) * s, c + Vector2(-0.14, 0) * s]), "cinza_pedra")
		"mapa":
			_rect(canvas, Rect2(c + Vector2(-1.0, -0.75) * s, Vector2(2.0, 1.5) * s), "bege")
			canvas.draw_line(c + Vector2(-0.33, -0.75) * s, c + Vector2(-0.33, 0.75) * s, Palette.color("marrom"), s * 0.05)
			canvas.draw_line(c + Vector2(0.33, -0.75) * s, c + Vector2(0.33, 0.75) * s, Palette.color("marrom"), s * 0.05)
			canvas.draw_polyline(PackedVector2Array([c + Vector2(-0.9, 0.1) * s, c + Vector2(-0.3, -0.2) * s, c + Vector2(0.3, 0.2) * s, c + Vector2(0.9, -0.1) * s]), Palette.color("azul_agua"), s * 0.12)
			canvas.draw_line(c + Vector2(0.35, -0.5) * s, c + Vector2(0.7, -0.15) * s, Palette.color("vermelho"), s * 0.1)
			canvas.draw_line(c + Vector2(0.7, -0.5) * s, c + Vector2(0.35, -0.15) * s, Palette.color("vermelho"), s * 0.1)
		"corda":
			_poly(canvas, octagon(c, s), "bege")
			_poly(canvas, octagon(c, s * 0.62), "marrom")
			_poly(canvas, octagon(c, s * 0.5), "bege")
			_poly(canvas, octagon(c, s * 0.28), "marrom_escuro")
		"lanterna":
			_poly(canvas, PackedVector2Array([c + Vector2(-0.45, -0.45) * s, c + Vector2(0.45, -0.45) * s, c + Vector2(0.25, -0.75) * s, c + Vector2(-0.25, -0.75) * s]), "cinza_grafite")
			_rect(canvas, Rect2(c + Vector2(-0.4, -0.45) * s, Vector2(0.8, 1.0) * s), "amarelo_brasa")
			_rect(canvas, Rect2(c + Vector2(-0.5, 0.55) * s, Vector2(1.0, 0.2) * s), "cinza_grafite")
			canvas.draw_polyline(PackedVector2Array([c + Vector2(-0.25, -0.75) * s, c + Vector2(0, -1.0) * s, c + Vector2(0.25, -0.75) * s]), Palette.color("cinza_grafite"), s * 0.07)
		"cantil":
			_rect(canvas, Rect2(c + Vector2(-0.45, -0.55) * s, Vector2(0.9, 1.4) * s), "verde_folha")
			_rect(canvas, Rect2(c + Vector2(-0.22, -0.85) * s, Vector2(0.44, 0.32) * s), "marrom_escuro")
		"caixa":
			_rect(canvas, Rect2(c + Vector2(-0.75, -0.5) * s, Vector2(1.5, 1.1) * s), "marrom")
			_rect(canvas, Rect2(c + Vector2(-0.75, -0.3) * s, Vector2(1.5, 0.14) * s), "marrom_escuro")
			_rect(canvas, Rect2(c + Vector2(-0.75, 0.3) * s, Vector2(1.5, 0.14) * s), "marrom_escuro")
			_rect(canvas, Rect2(c + Vector2(-0.2, -0.1) * s, Vector2(0.4, 0.26) * s), "vermelho")
		"bandeira":
			_rect(canvas, Rect2(c + Vector2(-0.45, -0.9) * s, Vector2(0.12, 1.8) * s), "marrom_escuro")
			_poly(canvas, PackedVector2Array([c + Vector2(-0.33, -0.9) * s, c + Vector2(0.6, -0.55) * s, c + Vector2(-0.33, -0.2) * s]), "vermelho")
		"check":
			_rect(canvas, Rect2(c + Vector2(-0.8, -0.8) * s, Vector2(1.6, 1.6) * s), "verde_folha")
			canvas.draw_polyline(PackedVector2Array([c + Vector2(-0.45, 0.0) * s, c + Vector2(-0.1, 0.4) * s, c + Vector2(0.5, -0.4) * s]), Palette.color("cinza_claro"), s * 0.25)
		"vazio":
			canvas.draw_rect(Rect2(c + Vector2(-0.8, -0.8) * s, Vector2(1.6, 1.6) * s), Palette.color("marrom"), false, s * 0.14)
		"rosto":
			_rect(canvas, Rect2(c + Vector2(-0.9, -0.9) * s, Vector2(1.8, 1.8) * s), "verde_claro")
			_rect(canvas, Rect2(c + Vector2(-0.6, -0.55) * s, Vector2(1.2, 1.2) * s), "pele_3")
			_rect(canvas, Rect2(c + Vector2(-0.65, -0.7) * s, Vector2(1.3, 0.35) * s), "cabelo_castanho")
			_rect(canvas, Rect2(c + Vector2(-0.38, -0.12) * s, Vector2(0.22, 0.3) * s), "tinta")
			_rect(canvas, Rect2(c + Vector2(0.16, -0.12) * s, Vector2(0.22, 0.3) * s), "tinta")
			_rect(canvas, Rect2(c + Vector2(-0.3, 0.32) * s, Vector2(0.6, 0.12) * s), "tinta")
			_rect(canvas, Rect2(c + Vector2(-0.6, 0.52) * s, Vector2(1.2, 0.4) * s), "amarelo_lenco")
		_:
			push_error("ícone desconhecido: %s" % kind)
