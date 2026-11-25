class_name Missions
extends RefCounted
## Missões da campanha de José como dados (ADR-0010). Uma ativa por vez: a primeira ainda não concluída.
## kind "collect": conta os ids coletados. kind "deliver": conta os ids entregues na zona.

const LIST: Array[Dictionary] = [
	{"id": "colheita", "title": "Colheita", "kind": "collect", "prefix": "Trigo"},
	{"id": "transporte", "title": "Transporte", "kind": "deliver", "prefix": "Saco"},
]
