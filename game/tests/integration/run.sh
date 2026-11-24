#!/usr/bin/env bash
# Teste de integração (ADR-0008), sem interface:
#   1. servidor + 2 clientes em script (coleta validada, entrada adulterada, mensagens inválidas, saída de cliente);
#   2. outro servidor + 9 conexões: só 8 entram.
# Uso, na raiz do repositório:  GODOT=/caminho/do/godot bash game/tests/integration/run.sh
# (rode antes: godot --headless --path game --import)
set -u
: "${GODOT:?defina GODOT com o caminho do executável do Godot}"
PORT="${PORT:-17777}"
LOGS="$(mktemp -d)"
PIDS=()
trap 'kill "${PIDS[@]}" 2>/dev/null' EXIT

# start_server <porta> <log>: sobe o servidor e espera ficar pronto; guarda o pid em SERVER
start_server() {
	"$GODOT" --headless --path game res://server/server_world.tscn -- --port="$1" >"$2" 2>&1 &
	SERVER=$!
	PIDS+=("$SERVER")
	for _ in $(seq 100); do
		grep -q "servidor pronto" "$2" && return 0
		sleep 0.2
	done
	echo "FALHOU: servidor não subiu na porta $1"; cat "$2"; exit 1
}
godot_script() { "$GODOT" --headless --path game -s "$@"; }

status=0
fail() { echo "FALHOU: $1"; status=1; }

# 1. dois clientes
start_server "$PORT" "$LOGS/server.log"
SERVER1=$SERVER
bot() { godot_script res://tests/integration/bot.gd -- --role="$1" --port="$PORT" >"$LOGS/$1.log" 2>&1; }
bot a & A=$!
bot b & B=$!
wait "$A"; RA=$?
wait "$B"; RB=$?
kill -0 "$SERVER1" 2>/dev/null; ALIVE1=$?
[ "$RA" -eq 0 ] || fail "cliente a (código $RA)"
[ "$RB" -eq 0 ] || fail "cliente b (código $RB)"
[ "$ALIVE1" -eq 0 ] || fail "o servidor caiu"
grep -qE "ERROR|SCRIPT ERROR|Parse Error" "$LOGS/server.log" && fail "erros no log do servidor"

# 2. limite de jogadores
start_server "$((PORT + 1))" "$LOGS/server2.log"
SERVER2=$SERVER
godot_script res://tests/integration/fill.gd -- --port="$((PORT + 1))" >"$LOGS/fill.log" 2>&1; RF=$?
ENTRADAS="$(grep -c "entrou" "$LOGS/server2.log")"
kill -0 "$SERVER2" 2>/dev/null; ALIVE2=$?
[ "$RF" -eq 0 ] || fail "limite de jogadores (código $RF)"
[ "$ENTRADAS" -eq 8 ] || fail "o servidor registrou $ENTRADAS entradas, esperado 8"
[ "$ALIVE2" -eq 0 ] || fail "o servidor caiu com 9 conexões"

if [ "$status" -ne 0 ]; then
	for f in server a b server2 fill; do echo "----- $f.log"; cat "$LOGS/$f.log"; done
else
	echo "rede ok: 2 clientes, coleta validada pelo servidor, 9ª conexão recusada"
	grep -E "coletou|recusado" "$LOGS/server.log"
fi
exit "$status"
