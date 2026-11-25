class_name Roles
extends RefCounted
## Elenco histórico por função (opções para Figures.build). Simplificações inspiradas no antigo Oriente Próximo e no Egito,
## a revisar com quem conheça o período. Nenhuma função carrega arma em destaque.

# ---- José (Egito) ----


static func jose_jovem() -> Dictionary:
	return {"name": "José jovem", "skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto", "mood": "sereno",
		"outfit": "tunica", "hem": 0.3, "main": "linho", "trim": "terracota", "sash": "azul_nilo", "items": ["cajado"], "height": 0.97}


static func jose_administrador() -> Dictionary:
	return {"name": "José administrador", "skin": "pele_3", "hair": "cabelo_preto", "hair_style": "curto", "mood": "determinado",
		"outfit": "tunica_longa", "main": "linho", "trim": "dourado_trigo", "sash": "azul_nilo", "collar": true, "items": ["rolo"], "height": 1.02}


static func trabalhador() -> Dictionary:
	return {"name": "Trabalhador", "skin": "pele_4", "hair": "cabelo_preto", "hair_style": "pano", "hat": "linho", "mood": "sorriso",
		"outfit": "saiote", "main": "linho", "trim": "ocre", "items": ["cesto"], "height": 0.98, "girth": 1.05}


static func guardiao_celeiro() -> Dictionary:
	return {"name": "Responsável pelo celeiro", "skin": "pele_5", "hair": "cabelo_preto", "hair_style": "curto", "mood": "determinado",
		"outfit": "saiote_longo", "main": "linho", "trim": "ocre", "strap": true, "items": ["tabuleta"], "height": 1.04, "girth": 1.08}


static func comerciante() -> Dictionary:
	return {"name": "Comerciante", "skin": "pele_2", "hair": "cabelo_castanho", "hair_style": "pano", "hat": "ocre", "mood": "sorriso",
		"outfit": "tunica", "hem": 0.32, "main": "terracota", "trim": "ocre", "sash": "marrom_escuro", "items": ["jarro", "bolsa"], "girth": 1.1}


static func viajante() -> Dictionary:
	return {"name": "Viajante", "skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto", "beard": "curta", "mood": "sereno",
		"outfit": "tunica", "hem": 0.3, "main": "adobe", "trim": "marrom", "sash": "marrom_escuro", "cape": "marrom", "items": ["cajado", "bolsa"], "height": 1.02}


static func morador() -> Dictionary:
	return {"name": "Moradora da cidade", "skin": "pele_1", "hair": "cabelo_preto", "hair_style": "peruca", "mood": "sorriso",
		"outfit": "tunica_longa", "main": "linho", "trim": "azul_nilo", "sash": "dourado_trigo", "collar": true, "height": 0.95}


# ---- Daniel (Babilônia) ----


## fase: 0 jovem, 1 adulto, 2 idoso.
static func daniel(fase: int = 1) -> Dictionary:
	var o := {"name": "Daniel", "skin": "pele_3", "hair": "cabelo_preto", "hair_style": "cachos", "mood": "sereno",
		"outfit": "robe", "main": "azul_petroleo", "trim": "dourado_antigo", "sash": "creme", "items": ["rolo"]}
	match fase:
		0:
			o["name"] = "Daniel jovem"
			o["height"] = 0.96
		2:
			o["name"] = "Daniel idoso"
			o["beard"] = "longa"
			o["hair"] = "cabelo_cinza"
			o["height"] = 0.98
		_:
			o["name"] = "Daniel adulto"
			o["beard"] = "curta"
	return o


static func companheiro(i: int) -> Dictionary:
	var set := [
		{"name": "Companheiro", "skin": "pele_2", "hair": "cabelo_castanho", "hair_style": "curto", "outfit": "robe", "main": "tijolo", "trim": "creme", "sash": "dourado_antigo", "mood": "sorriso", "height": 0.98},
		{"name": "Companheiro", "skin": "pele_4", "hair": "cabelo_preto", "hair_style": "cachos", "beard": "curta", "outfit": "robe", "main": "creme", "trim": "azul_lapis", "sash": "tijolo", "mood": "sereno", "height": 1.03},
		{"name": "Companheiro", "skin": "pele_3", "hair": "cabelo_ruivo", "hair_style": "curto", "outfit": "robe", "main": "azul_lapis", "trim": "dourado_antigo", "sash": "creme", "mood": "determinado", "height": 0.97},
	]
	return set[i % set.size()]


static func oficial() -> Dictionary:
	return {"name": "Oficial da corte", "skin": "pele_2", "hair": "cabelo_preto", "hair_style": "chapeu", "hat": "creme", "beard": "cachos", "mood": "sereno",
		"outfit": "robe", "main": "azul_lapis", "trim": "dourado_antigo", "sash": "dourado_antigo", "cape": "tijolo", "items": ["tabuleta"], "height": 1.04}


static func escriba() -> Dictionary:
	return {"name": "Escriba", "skin": "pele_3", "hair": "cabelo_castanho", "hair_style": "curto", "mood": "sereno",
		"outfit": "tunica_longa", "main": "creme", "trim": "tijolo", "sash": "marrom", "items": ["bolsa", "tabuleta"]}


static func sabio() -> Dictionary:
	return {"name": "Sábio", "skin": "pele_2", "hair": "cabelo_cinza", "hair_style": "curto", "beard": "longa", "mood": "sereno",
		"outfit": "robe", "main": "azul_petroleo", "trim": "dourado_antigo", "sash": "creme", "cape": "creme", "items": ["rolo"], "height": 0.97}


static func guarda_cerimonial() -> Dictionary:
	return {"name": "Guarda cerimonial", "skin": "pele_5", "hair": "cabelo_preto", "hair_style": "chapeu", "hat": "tijolo", "beard": "curta", "mood": "determinado",
		"outfit": "tunica", "hem": 0.26, "main": "tijolo", "trim": "dourado_antigo", "sash": "dourado_antigo", "items": ["cajado_cerimonial"], "height": 1.08, "girth": 1.06}


static func servidor() -> Dictionary:
	return {"name": "Servidor", "skin": "pele_4", "hair": "cabelo_preto", "hair_style": "curto", "mood": "sorriso",
		"outfit": "tunica", "hem": 0.34, "main": "adobe", "trim": "marrom", "sash": "creme", "items": ["jarro"], "height": 0.97}
