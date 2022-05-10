# Posicion de un punto de una cuerda verlet
class_name PuntoVerlet
extends Node

var pos_actual : Vector2
var pos_vieja : Vector2 # Posicion del frame anterior
var sig_segmento : PuntoVerlet

func _init(_pos : Vector2) -> void:
	pos_actual = _pos
