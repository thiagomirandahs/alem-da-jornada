extends RefCounted


func test_le_valor_da_opcao() -> String:
	var v := CmdArgs.value(PackedStringArray(["--port=9000", "--bind=0.0.0.0"]), "bind", "x")
	return "" if v == "0.0.0.0" else "obtido '%s'" % v


func test_usa_padrao_quando_ausente() -> String:
	var v := CmdArgs.value(PackedStringArray(["--port=9000"]), "connect", "padrao")
	return "" if v == "padrao" else "obtido '%s'" % v


func test_nao_confunde_prefixo_parecido() -> String:
	var v := CmdArgs.value(PackedStringArray(["--portal=1"]), "port", "padrao")
	return "" if v == "padrao" else "obtido '%s'" % v
