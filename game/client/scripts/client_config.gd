class_name ClientConfig
extends RefCounted
## O que a tela de conexão passa para o cliente de rede, e o erro a mostrar quando a conexão volta para ela.

const CONNECT_SCENE := "res://client/scenes/connect_screen.tscn"
const NET_SCENE := "res://client/scenes/net_client.tscn"

static var address := ""
static var last_error := ""
static var from_menu := false # false quando o endereço veio de --connect (PC): erro encerra o programa


## "host:porta" vira [host, porta]. Retorna [] se faltar o host ou a porta não for um número de 1 a 65535.
static func parse(text: String) -> Array:
	var parts := text.strip_edges().rsplit(":", true, 1)
	if parts.size() != 2 or parts[0].is_empty() or not parts[1].is_valid_int():
		return []
	var port := parts[1].to_int()
	if port < 1 or port > 65535:
		return []
	return [parts[0], port]
