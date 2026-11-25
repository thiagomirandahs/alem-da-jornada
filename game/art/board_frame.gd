class_name BoardFrame
extends RefCounted
## Cabeçalho e rodapé idênticos em todas as pranchas: é o que as faz parecerem uma coleção só.
## Medidas em pixels da imagem de trabalho (3840x2160), que é reduzida à metade no PNG final.

const SIZE := Vector2i(3840, 2160)
const HEADER_HEIGHT := 150.0
const FOOTER_HEIGHT := 18.0


static func build(number: int, title: String, subtitle: String) -> CanvasLayer:
	var layer := CanvasLayer.new()
	layer.layer = 10

	_rect(layer, Vector2.ZERO, Vector2(SIZE.x, HEADER_HEIGHT), "marrom_escuro")
	_text(layer, "ALÉM DA JORNADA", Vector2(90, 38), 72, "bege")
	_text(layer, "%02d  ·  %s" % [number, title.to_upper()], Vector2(1100, 38), 72, "amarelo_lenco")
	_text(layer, subtitle, Vector2(2250, 56), 42, "creme") # até ~44 caracteres, para caber entre o título e as amostras de cor

	# As cinco cores de referência do guia, no canto do cabeçalho
	for i in Palette.REFERENCE.size():
		_rect(layer, Vector2(SIZE.x - 90 - (Palette.REFERENCE.size() - i) * 100, 36), Vector2(78, 78), Palette.REFERENCE[i])

	# Rodapé com a mesma sequência de cores
	var step := SIZE.x / float(Palette.REFERENCE.size())
	for i in Palette.REFERENCE.size():
		_rect(layer, Vector2(i * step, SIZE.y - FOOTER_HEIGHT), Vector2(step, FOOTER_HEIGHT), Palette.REFERENCE[i])
	return layer


static func _rect(parent: Node, pos: Vector2, size: Vector2, color_name: String) -> ColorRect:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = size
	rect.color = Palette.color(color_name)
	parent.add_child(rect)
	return rect


static func _text(parent: Node, text: String, pos: Vector2, font_size: int, color_name: String) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Palette.color(color_name))
	parent.add_child(label)
	return label
