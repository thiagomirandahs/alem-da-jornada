extends SceneTree
## Renderiza as pranchas de referência em PNG 1920x1080 (renderizadas em 3840x2160 e reduzidas, para suavizar as bordas).
## Precisa de janela (GPU): não roda com --headless.
## Uso: godot --path game -s res://art/render_boards.gd -- [--only=01] [--out=../docs/art/pranchas]

const WORK_SIZE := Vector2i(3840, 2160)
const FINAL_SIZE := Vector2i(1920, 1080)

# número, nome do arquivo, função que monta a prancha
var _boards: Array = []


func _initialize() -> void:
	_boards = [
		[1, "01-character-design", Board01Characters.build],
		[2, "02-uniform-design", Board02Uniform.build],
		[3, "03-environment-design", Board03Environment.build],
		[4, "04-nature-assets", Board04Nature.build],
		[5, "05-props-design", Board05Props.build],
		[6, "06-visual-effects", Board06Effects.build],
		[7, "07-ui-design", Board07Ui.build],
		[8, "08-color-and-lighting", Board08ColorLight.build],
	]
	var args := OS.get_cmdline_user_args()
	var only := CmdArgs.value(args, "only", "")
	var out := CmdArgs.value(args, "out", "../docs/art/pranchas")
	var out_dir := out if out.is_absolute_path() else ProjectSettings.globalize_path("res://").path_join(out).simplify_path()
	DirAccess.make_dir_recursive_absolute(out_dir)
	for board in _boards:
		if only != "" and not (board[1] as String).begins_with(only):
			continue
		await _render(board[1], board[2], out_dir)
	if only == "":
		_contact_sheet(out_dir)
	quit()


## Folha de contato 4x2 com as oito pranchas lado a lado, para comparar o estilo de uma vez.
func _contact_sheet(out_dir: String) -> void:
	var cell := Vector2i(960, 540)
	var sheet := Image.create(cell.x * 4, cell.y * 2, false, Image.FORMAT_RGB8)
	sheet.fill(Palette.color("cinza_claro"))
	for i in _boards.size():
		var image := Image.load_from_file(out_dir.path_join("%s.png" % _boards[i][1]))
		image.convert(Image.FORMAT_RGB8)
		image.resize(cell.x, cell.y, Image.INTERPOLATE_LANCZOS)
		sheet.blit_rect(image, Rect2i(Vector2i.ZERO, cell), Vector2i((i % 4) * cell.x, (i / 4) * cell.y))
	var path := out_dir.path_join("00-folha-de-contato.png")
	print("folha de contato -> %s (%s)" % [path, "ok" if sheet.save_png(path) == OK else "erro"])


func _render(file: String, build: Callable, out_dir: String) -> void:
	var viewport := SubViewport.new()
	viewport.size = WORK_SIZE
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	viewport.add_child(build.call())
	for i in 6: # alguns quadros para as sombras e o layout assentarem
		await process_frame
	await RenderingServer.frame_post_draw
	var image := viewport.get_texture().get_image()
	image.resize(FINAL_SIZE.x, FINAL_SIZE.y, Image.INTERPOLATE_LANCZOS)
	var path := out_dir.path_join("%s.png" % file)
	var err := image.save_png(path)
	print("%s -> %s (%s)" % [file, path, "ok" if err == OK else "erro %d" % err])
	viewport.queue_free()
