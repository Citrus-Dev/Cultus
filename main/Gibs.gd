class_name Gibs
extends Node2D

const RAND_RANGO := 0.4
const FUERZA_EXPULSION := 450.0

export(Array, NodePath) var gibs_paths
export(NodePath) var punto_de_expulsion_path

var gibs := []
var punto_de_expulsion : Position2D

func _ready():
	punto_de_expulsion = get_node(punto_de_expulsion_path)
	tomar_gibs()
	expulsar_gibs()


func tomar_gibs():
	for i in gibs_paths:
		gibs.append(get_node(i))


func expulsar_gibs():
	for i in gibs:
		var gib = i as GibFisicas
		gib.velocity = tomar_direccion_de_expulsion(gib.global_position)


func tomar_direccion_de_expulsion(pos : Vector2) -> Vector2:
	var variacion = rand_range(1 - RAND_RANGO, 1 + RAND_RANGO)
	var fuerza = ((pos - punto_de_expulsion.global_position).normalized() * FUERZA_EXPULSION) * variacion
	return fuerza
