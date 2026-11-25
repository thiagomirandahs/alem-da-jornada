class_name ServerStats
extends RefCounted
## Estatísticas do servidor, ligadas por --stats, para a medição de carga (issue #5).
## A linha impressa por report() é lida por game/tests/performance/run.sh: mude os dois juntos.

var _tick_usec: Array[int] = []


func record_tick(usec: int) -> void:
	_tick_usec.append(usec)


## Menor valor que cobre a fração p (0 a 1) das amostras, já ordenadas (posto mais próximo). Vazio dá 0.
static func percentile(sorted_values: Array[int], p: float) -> int:
	if sorted_values.is_empty():
		return 0
	return sorted_values[clampi(ceili(p * sorted_values.size()) - 1, 0, sorted_values.size() - 1)]


## Linha da janela que acabou de passar (seconds de duração); depois disso, zera as amostras.
func report(players: int, seconds: float, sent_bytes: float, recv_bytes: float, memory_bytes: int) -> String:
	_tick_usec.sort()
	var count := _tick_usec.size()
	var total := 0
	for usec in _tick_usec:
		total += usec
	var line := "stats players=%d ticks_s=%.1f tick_ms_avg=%.3f tick_ms_p95=%.3f tick_ms_max=%.3f mem_mb=%.1f sent_kbs=%.1f recv_kbs=%.1f" % [
		players,
		count / seconds,
		float(total) / maxf(count, 1.0) / 1000.0,
		percentile(_tick_usec, 0.95) / 1000.0,
		percentile(_tick_usec, 1.0) / 1000.0,
		memory_bytes / 1048576.0,
		sent_bytes / seconds / 1024.0,
		recv_bytes / seconds / 1024.0,
	]
	_tick_usec.clear()
	return line
