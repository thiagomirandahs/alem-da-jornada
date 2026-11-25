extends Control
## Tela de conexão: o jogador digita ip:porta do servidor. O último endereço fica guardado no aparelho.

const CONFIG_PATH := "user://client.cfg"

@onready var _address: LineEdit = %Address
@onready var _status: Label = %Status


func _ready() -> void:
	var config := ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		_address.text = str(config.get_value("server", "address", ""))
	_status.text = ClientConfig.last_error
	ClientConfig.last_error = ""
	%Connect.pressed.connect(_connect)
	_address.text_submitted.connect(_connect_from_text)


func _connect_from_text(_text: String) -> void:
	_connect()


func _connect() -> void:
	var text := _address.text.strip_edges()
	if ClientConfig.parse(text).is_empty():
		_status.text = "Use o formato ip:porta, por exemplo 192.168.0.10:7777"
		return
	var config := ConfigFile.new()
	config.set_value("server", "address", text)
	config.save(CONFIG_PATH)
	ClientConfig.address = text
	ClientConfig.from_menu = true
	get_tree().change_scene_to_file(ClientConfig.NET_SCENE)
