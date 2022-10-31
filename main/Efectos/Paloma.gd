class_name Paloma
extends Node2D

const ACC_HORIZONTAL: float = 1.5
const MAX_VEL_HORIZONTAL: float = 5.0
const ACC_VERTICAL: float = -3.5
const MAX_VEL_VERTICAL: float = 5.0
const DISTANCIA_DESPAWN: float = 512.0

var velocity: Vector2 = Vector2(1.0, 2.5)
var dir: int = 1
var pos_spawn: Vector2

onready var sprite: AnimatedSprite = $AnimatedSprite


func _ready():
	set_as_toplevel(true)
	pos_spawn = global_position



func _process(delta):
	velocity.x = clamp(velocity.x + (ACC_HORIZONTAL * dir) * delta, -MAX_VEL_HORIZONTAL, MAX_VEL_HORIZONTAL)
	velocity.y = clamp(velocity.y + ACC_VERTICAL * delta, -MAX_VEL_VERTICAL, MAX_VEL_VERTICAL)
	
	global_position += velocity
	
	dir = sign(velocity.x)
	sprite.flip_h = true if dir == -1 else false
	
	if pos_spawn.distance_to(global_position) > DISTANCIA_DESPAWN:
		call_deferred("free")
