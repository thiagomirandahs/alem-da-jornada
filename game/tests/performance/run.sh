#!/usr/bin/env bash
# Medição de carga (issue #5): servidor com --stats + N clientes que andam.
# Por dentro (--stats): ticks por segundo, tempo de tick, rede. Por fora: CPU (% de 1 núcleo) e memória do processo.
# Uso, na raiz do repositório:
#   GODOT=/caminho/do/godot bash game/tests/performance/run.sh [segundos=60] [repetições=3] ["jogadores"="1 2 4 8"]
# (rode antes: godot --headless --path game --import)
# Limitação: servidor e clientes disputam a mesma máquina, então os números são pessimistas.
set -u
: "${GODOT:?defina GODOT com o caminho do executável do Godot}"
SECONDS_PER_RUN="${1:-60}"
REPEATS="${2:-3}"
PLAYERS_LIST="${3:-1 2 4 8}"
PORT="${PORT:-17800}"
WARMUP=5
LOGS="$(mktemp -d)"
PIDS=()
trap 'kill "${PIDS[@]}" 2>/dev/null' EXIT

case "$(uname -s)" in MINGW* | MSYS* | CYGWIN*) WINDOWS=1 ;; *) WINDOWS=0 ;; esac

# server_pid <porta> <pid do bash>: no Windows o executável "console" é só um invólucro; o processo real é o filho.
server_pid() {
	if [ "$WINDOWS" -eq 1 ]; then
		powershell -NoProfile -Command "(Get-CimInstance Win32_Process | Where-Object { \$_.Name -like 'Godot*' -and \$_.Name -notlike '*console*' -and \$_.CommandLine -match 'server_world' -and \$_.CommandLine -match '--port=$1' }).ProcessId" | tr -d '\r'
	else
		echo "$2"
	fi
}

# sample <pid>: imprime "segundos_de_cpu memória_mb"
sample() {
	if [ "$WINDOWS" -eq 1 ]; then
		powershell -NoProfile -Command "\$p = Get-Process -Id $1; '{0} {1}' -f \$p.TotalProcessorTime.TotalSeconds, [math]::Round(\$p.WorkingSet64/1MB, 1)" | tr -d '\r' | tr ',' '.'
	else
		awk -v tck="$(getconf CLK_TCK)" -v rss="$(awk '/VmRSS/ {print $2 / 1024}' "/proc/$1/status")" '{print ($14 + $15) / tck, rss}' "/proc/$1/stat"
	fi
}

# median_of <campo>: mediana do campo (ex.: tick_ms_p95) nas linhas "stats" lidas da entrada
median_of() {
	grep -o "$1=[0-9.]*" | cut -d= -f2 | sort -n | awk '{v[NR] = $1} END {if (NR == 0) exit 1; print (NR % 2 ? v[(NR + 1) / 2] : (v[NR / 2] + v[NR / 2 + 1]) / 2)}'
}

printf '%-8s %-4s %-8s %-8s %-8s %-12s %-12s %-9s %-9s\n' jogadores run cpu_pct mem_mb ticks_s tick_ms_p95 tick_ms_max sent_kbs recv_kbs
status=0
for N in $PLAYERS_LIST; do
	for RUN in $(seq "$REPEATS"); do
		LOG="$LOGS/server-$N-$RUN.log"
		"$GODOT" --headless --path game res://server/server_world.tscn -- --port="$PORT" --stats >"$LOG" 2>&1 &
		SRV=$!
		PIDS+=("$SRV")
		for _ in $(seq 100); do grep -q "servidor pronto" "$LOG" && break; sleep 0.2; done
		SPID="$(server_pid "$PORT" "$SRV")"
		for i in $(seq "$N"); do
			"$GODOT" --headless --path game -s res://tests/performance/walker.gd -- --port="$PORT" --seconds=$((SECONDS_PER_RUN + WARMUP + 40)) --seed="$((RUN * 100 + i))" >"$LOGS/walker-$N-$RUN-$i.log" 2>&1 &
			PIDS+=("$!")
		done
		# espera todos os clientes entrarem e deixa esquentar
		for _ in $(seq 200); do grep -q "stats players=$N " "$LOG" && break; sleep 0.5; done
		sleep "$WARMUP"
		read -r CPU0 _ < <(sample "$SPID"); T0=$(date +%s.%N)
		sleep "$SECONDS_PER_RUN"
		read -r CPU1 MEM < <(sample "$SPID"); T1=$(date +%s.%N)
		CPU_PCT="$(awk -v a="$CPU0" -v b="$CPU1" -v t0="$T0" -v t1="$T1" 'BEGIN {printf "%.1f", (b - a) / (t1 - t0) * 100}')"
		# linhas de estatística da janela medida: só com todos os jogadores, sem a primeira (janela parcial)
		LINES="$(grep "stats players=$N " "$LOG" | tail -n +2)"
		if [ -z "$LINES" ] || [ -z "$CPU_PCT" ]; then
			echo "FALHOU: sem medição para $N jogador(es), repetição $RUN"; cat "$LOG"; status=1
		else
			printf '%-8s %-4s %-8s %-8s %-8s %-12s %-12s %-9s %-9s\n' "$N" "$RUN" "$CPU_PCT" "$MEM" \
				"$(echo "$LINES" | median_of ticks_s)" "$(echo "$LINES" | median_of tick_ms_p95)" \
				"$(echo "$LINES" | grep -o 'tick_ms_max=[0-9.]*' | cut -d= -f2 | sort -n | tail -1)" \
				"$(echo "$LINES" | median_of sent_kbs)" "$(echo "$LINES" | median_of recv_kbs)"
		fi
		kill "${PIDS[@]}" 2>/dev/null; wait 2>/dev/null; PIDS=()
		grep -E "FALHOU" "$LOGS"/walker-"$N"-"$RUN"-*.log 2>/dev/null | head -2
	done
done
exit "$status"
