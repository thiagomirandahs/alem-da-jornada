extends RefCounted


func test_endereco_valido() -> String:
	return _expect(["192.168.0.10", 7777], ClientConfig.parse("192.168.0.10:7777"))


func test_endereco_com_espacos_e_nome() -> String:
	return _expect(["meu-pc.local", 9000], ClientConfig.parse("  meu-pc.local:9000 "))


func test_enderecos_invalidos() -> String:
	for text in ["", "192.168.0.10", ":7777", "host:", "host:abc", "host:0", "host:70000", "host:-5"]:
		if not ClientConfig.parse(text).is_empty():
			return "deveria recusar '%s'" % text
	return ""


func _expect(expected: Array, actual: Array) -> String:
	return "" if expected == actual else "esperado %s, obtido %s" % [expected, actual]
