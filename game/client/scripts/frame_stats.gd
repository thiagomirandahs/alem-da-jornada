class_name FrameStats
extends RefCounted
## Tempo de quadro do cliente, para medir o desempenho em aparelho (issue #7). Só builds de debug usam.

var seconds := 0.0 # duração acumulada da janela atual
var _ms := PackedFloat32Array()


func record(delta: float) -> void:
	_ms.append(delta * 1000.0)
	seconds += delta


## Linha da janela atual, depois zera. Vazia se não houve quadros.
func report() -> String:
	var count := _ms.size()
	if count == 0:
		return ""
	_ms.sort()
	var total := 0.0
	for ms in _ms:
		total += ms
	var line := "client frames=%d fps=%.1f frame_ms_avg=%.2f frame_ms_p95=%.2f frame_ms_max=%.2f" % [
		count, count / seconds, total / count, _ms[ceili(0.95 * count) - 1], _ms[count - 1]]
	_ms.clear()
	seconds = 0.0
	return line
