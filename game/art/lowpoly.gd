class_name LowPoly
extends RefCounted
## Formas facetadas e materiais foscos do kit de estilo. É o único jeito de criar geometria nas pranchas.
## Faces sempre planas (sem suavização), material fosco sem textura, cor sempre da Palette.

static var _materials := {}


## Material fosco da paleta. Um por cor, compartilhado: o mesmo "azul_agua" é igual em todo lugar.
static func material(color_name: String) -> StandardMaterial3D:
	if not _materials.has(color_name):
		var m := StandardMaterial3D.new()
		m.albedo_color = Palette.color(color_name)
		m.roughness = 1.0
		m.metallic = 0.0
		m.metallic_specular = 0.0
		m.set_meta("palette_name", color_name)
		_materials[color_name] = m
	return _materials[color_name]


## Material de efeito (brilho, poeira, névoa, fumaça): translúcido e sem sombra, mas com cor da paleta e sem textura.
## Só os efeitos usam; modelos sólidos usam material().
static func effect_material(color_name: String, alpha: float) -> StandardMaterial3D:
	var key := "fx:%s:%.2f" % [color_name, alpha]
	if not _materials.has(key):
		var m := StandardMaterial3D.new()
		m.albedo_color = Color(Palette.color(color_name), alpha)
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		m.set_meta("palette_name", color_name)
		m.set_meta("effect", true)
		_materials[key] = m
	return _materials[key]


static func node(mesh: Mesh, color_name: String, pos: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	n.mesh = mesh
	n.material_override = material(color_name)
	n.position = pos
	n.rotation_degrees = rot_deg
	n.set_meta("lowpoly", true)
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	return n


## Caixa centrada na origem.
static func box(size: Vector3, color_name: String, pos: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	return node(mesh, color_name, pos, rot_deg)


## Prisma (ou tronco de cone) com `sides` lados: base em y=0, topo em y=height. Raio do topo 0 faz uma pirâmide.
static func prism(sides: int, r_bottom: float, r_top: float, height: float, color_name: String, pos: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO, spin_deg: float = 0.0) -> MeshInstance3D:
	return node(prism_mesh(sides, r_bottom, r_top, height, spin_deg), color_name, pos, rot_deg)


static func pyramid(sides: int, radius: float, height: float, color_name: String, pos: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	return prism(sides, radius, 0.0, height, color_name, pos, rot_deg)


## spin_deg gira os vértices em torno do eixo do prisma (para apontar a ponta de um triângulo para onde se quer).
static func prism_mesh(sides: int, r_bottom: float, r_top: float, height: float, spin_deg: float = 0.0) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1) # faces planas
	var bottom: Array[Vector3] = []
	var top: Array[Vector3] = []
	for i in sides:
		var a := TAU * (float(i) + 0.5) / float(sides) + deg_to_rad(spin_deg) # faces alinhadas aos eixos quando sides = 4
		bottom.append(Vector3(cos(a) * r_bottom, 0.0, sin(a) * r_bottom))
		top.append(Vector3(cos(a) * r_top, height, sin(a) * r_top))
	var apex := Vector3(0.0, height, 0.0)
	for i in sides:
		var j := (i + 1) % sides
		if r_top <= 0.0001:
			_tri(st, bottom[i], apex, bottom[j])
		else:
			_tri(st, bottom[i], top[i], top[j])
			_tri(st, bottom[i], top[j], bottom[j])
		_tri(st, Vector3.ZERO, bottom[i], bottom[j]) # tampa de baixo
		if r_top > 0.0001:
			_tri(st, apex, top[j], top[i]) # tampa de cima
	st.generate_normals()
	return st.commit()


# O Godot considera frente a face em sentido horário; por isso a ordem a, c, b.
static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.add_vertex(a)
	st.add_vertex(c)
	st.add_vertex(b)


## Triângulos de toda a geometria sob `root` (para o orçamento do kit).
static func triangles(root: Node) -> int:
	var count := 0
	if root is MeshInstance3D and (root as MeshInstance3D).mesh != null:
		count += (root as MeshInstance3D).mesh.get_faces().size() / 3
	for child in root.get_children():
		count += triangles(child)
	return count
