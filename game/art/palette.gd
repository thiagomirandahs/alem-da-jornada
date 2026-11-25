class_name Palette
extends RefCounted
## Paleta única do jogo (docs/art/direcao-de-arte.md). Todo material do kit sai daqui e de nenhum outro lugar.

const COLORS := {
	# Guia do autor
	"marrom": Color("#B1611F"),
	"vermelho": Color("#77170C"),
	"verde_floresta": Color("#404F32"),
	"bege": Color("#E5DBC6"),
	"cinza_claro": Color("#F4F5F8"),
	# Complementares (propostas)
	"amarelo_lenco": Color("#F2C230"),
	"azul_ceu": Color("#8DB8D9"),
	"creme": Color("#F3E6CF"),
	"azul_agua": Color("#4A9CC2"),
	"espuma": Color("#E8F3F7"),
	"verde_folha": Color("#6E9B4A"),
	"verde_claro": Color("#A3C46F"),
	"marrom_escuro": Color("#6B3A14"),
	"cinza_pedra": Color("#9AA0A8"),
	"cinza_grafite": Color("#5B6068"),
	"laranja_fogo": Color("#E8832A"),
	"amarelo_brasa": Color("#F7C948"),
	"noite": Color("#2B2A33"),
	"rosa_flor": Color("#D9708A"),
	"azul_flor": Color("#5C7FC4"),
	"tinta": Color("#2A2019"), # olhos, boca e contornos
	"rosa_bochecha": Color("#E59A8A"),
	# Tons de pele
	"pele_1": Color("#F3CBA8"),
	"pele_2": Color("#E2A87A"),
	"pele_3": Color("#C48A5A"),
	"pele_4": Color("#8D5A36"),
	"pele_5": Color("#5B3A24"),
	# Cabelos
	"cabelo_preto": Color("#2A2019"),
	"cabelo_castanho": Color("#5A3A22"),
	"cabelo_loiro": Color("#C79B52"),
	"cabelo_ruivo": Color("#9A4A25"),
	"cabelo_cinza": Color("#9AA0A8"),
}

const SKINS: Array[String] = ["pele_1", "pele_2", "pele_3", "pele_4", "pele_5"]
const HAIRS: Array[String] = ["cabelo_preto", "cabelo_castanho", "cabelo_loiro", "cabelo_ruivo", "cabelo_cinza"]
# As cinco cores de referência do guia, na ordem em que aparecem nas pranchas.
const REFERENCE: Array[String] = ["marrom", "vermelho", "verde_floresta", "bege", "cinza_claro"]


const ACCENTED := {
	"azul_ceu": "azul céu", "azul_agua": "azul água", "amarelo_lenco": "amarelo lenço",
	"laranja_fogo": "laranja fogo", "amarelo_brasa": "amarelo brasa", "verde_folha": "verde folha",
}


## Nome para mostrar nas pranchas, em português e com acento.
static func display_name(color_name: String) -> String:
	return ACCENTED.get(color_name, color_name.replace("_", " "))


static func color(color_name: String) -> Color:
	assert(COLORS.has(color_name), "cor fora da paleta: %s" % color_name)
	return COLORS[color_name]
