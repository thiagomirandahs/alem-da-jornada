extends RefCounted


func test_percentil_por_posto_mais_proximo() -> String:
	var values: Array[int] = []
	for i in range(1, 101):
		values.append(i)
	var got := [ServerStats.percentile(values, 0.95), ServerStats.percentile(values, 1.0), ServerStats.percentile(values, 0.0)]
	return "" if got == [95, 100, 1] else "obtido %s, esperado [95, 100, 1]" % [got]


func test_percentil_de_lista_vazia_e_zero() -> String:
	var empty: Array[int] = []
	return "" if ServerStats.percentile(empty, 0.95) == 0 else "deveria ser 0"


func test_linha_do_relatorio_e_zera_as_amostras() -> String:
	var stats := ServerStats.new()
	for i in range(1, 101):
		stats.record_tick(i * 1000) # 1 ms a 100 ms
	var line := stats.report(3, 10.0, 10240.0, 20480.0, 2 * 1048576)
	var expected := "stats players=3 ticks_s=10.0 tick_ms_avg=50.500 tick_ms_p95=95.000 tick_ms_max=100.000 mem_mb=2.0 sent_kbs=1.0 recv_kbs=2.0"
	if line != expected:
		return "obtido '%s'" % line
	var empty_line := stats.report(0, 5.0, 0.0, 0.0, 0)
	return "" if empty_line.contains("ticks_s=0.0 tick_ms_avg=0.000") else "não zerou: '%s'" % empty_line
