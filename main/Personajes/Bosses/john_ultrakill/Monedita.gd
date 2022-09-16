class_name Monedita
extends KinematicBody2D

const VEL_MAX := 250.0
const GRAVEDAD := 100.0
const FRICCION_HORIZONTAL := 0.98

var velocity: Vector2

func _physics_process(delta):
	velocity.x *= FRICCION_HORIZONTAL
	velocity.y += GRAVEDAD * delta
	
	var coll: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if coll:
		call_deferred("free")
