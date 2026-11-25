class_name MiniCamp
extends RefCounted
## Cena pequena de acampamento, idêntica onde aparece (fundo do HUD na prancha 7, luz na prancha 8):
## só a luz muda entre as versões, nunca o material.


static func build(mood: Stage.Mood, background: String = "") -> Node3D:
	var root := Node3D.new()
	Stage.light(root, mood, background, false)
	root.add_child(LowPoly.box(Vector3(40, 0.5, 40), "verde_claro", Vector3(0, -0.25, -8)))
	root.add_child(LowPoly.prism(10, 3.4, 3.4, 0.06, "bege"))

	var tent := Props.tent("bege")
	tent.position = Vector3(-2.4, 0, -1.6)
	tent.rotation_degrees.y = 28.0
	root.add_child(tent)
	var fire := Props.campfire()
	fire.position = Vector3(0.1, 0, 0.0)
	root.add_child(fire)
	var crate := Props.crate()
	crate.position = Vector3(2.9, 0, -1.9)
	crate.rotation_degrees.y = 20.0
	root.add_child(crate)
	var lantern := Props.lantern()
	lantern.position = Vector3(2.9, 0.45, -1.9)
	root.add_child(lantern)
	var scout := Characters.build({"female": true, "skin": "pele_3", "hair": "cabelo_preto", "hair_style": "rabo"})
	scout.position = Vector3(1.5, 0, 1.0)
	scout.rotation_degrees.y = -30.0
	root.add_child(scout)
	var friend := Characters.build({"female": false, "skin": "pele_1", "hair": "cabelo_loiro", "hair_style": "franja"})
	friend.position = Vector3(-1.3, 0, 1.3)
	friend.rotation_degrees.y = 25.0
	root.add_child(friend)
	for spec in [[-5.0, -4.5, 4.2], [4.8, -5.0, 4.8], [0.5, -8.0, 5.4], [-8.5, -2.0, 4.0]]:
		var pine := Nature.pine(spec[2])
		pine.position = Vector3(spec[0], 0, spec[1])
		root.add_child(pine)
	var rock := Nature.rock(0.9)
	rock.position = Vector3(4.2, 0, 1.4)
	root.add_child(rock)
	var flowers := Nature.flowers()
	flowers.position = Vector3(-3.6, 0, 2.2)
	root.add_child(flowers)

	Stage.camera(root, Vector3(0.6, 2.1, 6.4), Vector3(0.2, 0.9, -0.8), 42.0)
	return root
