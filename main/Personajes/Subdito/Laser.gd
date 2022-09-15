class_name Laser
extends Node2D

onready var linea: Line2D = $Line2D
onready var raycast: RayCast2D = $RayCast2D

func _ready():
	linea.set_as_toplevel(true)


func _process(delta):
	raycast.force_raycast_update()
	var col = global_position - raycast.get_collision_point()
	linea.set_point_position(1, -col)
	linea.global_position = global_position
