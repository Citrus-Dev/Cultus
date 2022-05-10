class_name Resorte
extends Node2D

var STIFFNESS : float = 0.025
var FACTOR_DAMP : float = 0.025

var target_pos : Vector2
var velocity : Vector2


func _physics_process(delta):
	# Que tan lejos estamos de la posicion natural.
	var offset := global_position - target_pos
	var acel := -STIFFNESS * offset - (velocity * (STIFFNESS + FACTOR_DAMP))
	
	global_position += velocity
	velocity += acel


func _process(delta):
	return
	# Prueba; bajar el resorte si tocas click  
	if Input.is_action_just_pressed("disparo_primario"):
		var mousepos = get_global_mouse_position()
		global_position += global_position.direction_to(mousepos) * 25


func init_target_pos():
	target_pos = global_position
