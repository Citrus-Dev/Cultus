# Prueba
extends Polygon2D

export(NodePath) onready var root = get_node(root)

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var mouse_dir_ang = global_position.direction_to(mouse_pos).angle()
	rotation = mouse_dir_ang
