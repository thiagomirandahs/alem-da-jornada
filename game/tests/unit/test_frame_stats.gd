extends RefCounted


func test_linha_com_media_p95_e_maximo() -> String:
	var stats := FrameStats.new()
	for i in 19:
		stats.record(0.010) # 19 quadros de 10 ms
	stats.record(0.100) # e um engasgo de 100 ms
	var expected := "client frames=20 fps=69.0 frame_ms_avg=14.50 frame_ms_p95=10.00 frame_ms_max=100.00"
	var line := stats.report()
	return "" if line == expected else "obtido '%s'" % line


func test_zera_depois_de_reportar_e_vazio_sem_quadros() -> String:
	var stats := FrameStats.new()
	stats.record(0.016)
	stats.report()
	return "" if stats.report() == "" and stats.seconds == 0.0 else "não zerou"
