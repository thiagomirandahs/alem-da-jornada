extends SceneTree
## Executa os testes (ADR-0007): godot --headless --path game -s res://tests/run.gd
## Cada arquivo tests/unit/test_*.gd tem funções test_* que retornam "" quando passam
## ou a mensagem de falha. Sai com código 1 se algo falhar ou se nenhum teste for encontrado.

const TEST_DIR := "res://tests/unit/"


func _initialize() -> void:
	var passed := 0
	var failed := 0
	for file in DirAccess.get_files_at(TEST_DIR):
		if not (file.begins_with("test_") and file.ends_with(".gd")):
			continue
		var script := load(TEST_DIR + file) as GDScript
		if script == null or not script.can_instantiate():
			failed += 1
			printerr("FAIL %s: não foi possível carregar o arquivo" % file)
			continue
		var suite: Object = script.new()
		for method in suite.get_method_list():
			var test_name: String = method.name
			if not test_name.begins_with("test_"):
				continue
			var result: Variant = suite.call(test_name)
			if result is String and (result as String).is_empty():
				passed += 1
				print("ok   %s::%s" % [file, test_name])
			else:
				failed += 1
				printerr("FAIL %s::%s: %s" % [file, test_name, result])
	print("%d passaram, %d falharam" % [passed, failed])
	quit(1 if failed > 0 or passed == 0 else 0)
