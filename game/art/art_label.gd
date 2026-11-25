class_name ArtLabel
extends RefCounted
## Rótulo 3D padrão das pranchas: mesma fonte, mesmo peso e cor da paleta em todas.


## pixel_size: metros por pixel de fonte. Com font_size 96, 0.0026 dá letras de ~0,25 m.
static func make(text: String, pos: Vector3, pixel_size: float, color_name: String = "cinza_grafite", align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = 96
	label.pixel_size = pixel_size
	label.modulate = Palette.color(color_name)
	label.outline_size = 0
	label.horizontal_alignment = align
	label.position = pos
	label.shaded = false
	label.no_depth_test = true
	return label
