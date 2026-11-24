class_name CmdArgs
extends RefCounted
## Lê opções "--nome=valor" dos argumentos que vêm depois de "--" na linha de comando.


static func value(args: PackedStringArray, name: String, default: String) -> String:
	var prefix := "--%s=" % name
	for arg in args:
		if arg.begins_with(prefix):
			return arg.substr(prefix.length())
	return default
