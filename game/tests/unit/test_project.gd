extends RefCounted

const SCENES := [
	"res://client/scenes/test_world.tscn",
	"res://client/scenes/net_client.tscn",
	"res://server/server_world.tscn",
]


func test_acoes_de_movimento_tem_teclado_e_setas() -> String:
	for action in ["move_forward", "move_back", "move_left", "move_right"]:
		if not InputMap.has_action(action):
			return "ação %s não existe" % action
		if InputMap.action_get_events(action).size() != 2:
			return "ação %s deveria ter 2 teclas" % action
	return ""


func test_acao_interagir_existe() -> String:
	if not InputMap.has_action("interact") or InputMap.action_get_events("interact").is_empty():
		return "ação interact sem tecla"
	return ""


func test_cena_principal_tem_jogador_com_camera() -> String:
	var path: String = ProjectSettings.get_setting("application/run/main_scene")
	var world := (load(path) as PackedScene).instantiate()
	var has_camera := world.get_node_or_null("Player/CameraPivot/SpringArm/Camera") is Camera3D
	world.free()
	return "" if has_camera else "câmera do jogador não encontrada em %s" % path


func test_tela_de_conexao_tem_campo_e_botao() -> String:
	var screen := (load(ClientConfig.CONNECT_SCENE) as PackedScene).instantiate()
	var ok := screen.get_script() != null and screen.get_node_or_null("%Address") is LineEdit \
		and screen.get_node_or_null("%Connect") is Button and screen.get_node_or_null("%Status") is Label
	screen.free()
	return "" if ok else "tela de conexão sem script, Address, Connect ou Status"


func test_android_abre_na_tela_de_conexao() -> String:
	var main_scene: String = ProjectSettings.get_setting("application/run/main_scene.android", "")
	return "" if main_scene == ClientConfig.CONNECT_SCENE else "obtido '%s'" % main_scene


func test_cenas_de_rede_carregam_com_script_e_sessao() -> String:
	for path in SCENES:
		var scene := load(path) as PackedScene
		if scene == null:
			return "%s não carrega" % path
		var root := scene.instantiate()
		var ok := root.get_node_or_null("Level/Basket") != null
		if path != SCENES[0]:
			ok = ok and root.get_script() != null and root.get_node_or_null("Session") is Session
		root.free()
		if not ok:
			return "%s sem Level/Basket, script ou Session" % path
	return ""
