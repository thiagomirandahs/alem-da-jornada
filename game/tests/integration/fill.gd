extends SceneTree
## Abre 9 conexões ENet "cruas" contra o servidor e confere que só 8 são aceitas (limite de jogadores).
## Uso: godot --headless --path game -s res://tests/integration/fill.gd -- --port=17778

const ATTEMPTS := Session.MAX_PLAYERS + 1
const WAIT_MSEC := 4000


func _initialize() -> void:
	var port := CmdArgs.value(OS.get_cmdline_user_args(), "port", str(Session.PORT)).to_int()
	var hosts: Array[ENetConnection] = []
	for i in ATTEMPTS:
		var host := ENetConnection.new()
		host.create_host(1, 0)
		# o "data" é o id do jogador; sem um id válido (>= 2) o servidor descarta a conexão na hora e libera a vaga
		host.connect_to_host("127.0.0.1", port, 0, 1000 + i)
		hosts.append(host)
	var connected := 0
	var start := Time.get_ticks_msec()
	while Time.get_ticks_msec() - start < WAIT_MSEC:
		for host in hosts:
			if host.service(5)[0] == ENetConnection.EVENT_CONNECT:
				connected += 1
	print("conexões aceitas: %d de %d tentativas" % [connected, ATTEMPTS])
	for host in hosts:
		host.destroy()
	quit(0 if connected == Session.MAX_PLAYERS else 1)
