class_name UiDraw
extends Control
## Controle de desenho livre: o `painter` recebe este controle e desenha com draw_*. Usado nos ícones e no mapa da interface.

var painter: Callable


func _draw() -> void:
	if painter.is_valid():
		painter.call(self)


static func make(parent: Node, rect: Rect2, paint: Callable) -> UiDraw:
	var d := UiDraw.new()
	d.position = rect.position
	d.size = rect.size
	d.painter = paint
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(d)
	return d
