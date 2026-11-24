extends RefCounted


func test_acoes_de_movimento_tem_teclado_e_setas() -> String:
	for action in ["move_forward", "move_back", "move_left", "move_right"]:
		if not InputMap.has_action(action):
			return "ação %s não existe" % action
		if InputMap.action_get_events(action).size() != 2:
			return "ação %s deveria ter 2 teclas" % action
	return ""


func test_cena_principal_tem_jogador_com_camera() -> String:
	var path: String = ProjectSettings.get_setting("application/run/main_scene")
	var world := (load(path) as PackedScene).instantiate()
	var has_camera := world.get_node_or_null("Player/CameraPivot/SpringArm/Camera") is Camera3D
	world.free()
	return "" if has_camera else "câmera do jogador não encontrada em %s" % path
