class_name PiedraBoss
extends KinematicBody2D

const GRAVEDAD: float = 200.0
const MAX_BOUNCE: int = 3

var velocidad_rotacion: float
var velocity: Vector2
var col_counter: int

onready var sprite: Sprite = $Sprite
onready var drops: DropManager = $DropManager

func _process(delta):
	sprite.rotation += velocidad_rotacion * delta


func _physics_process(delta):
	var col: KinematicCollision2D = move_and_collide(velocity * delta, true, true)
	
	if col:
		col_counter += 1
		
		if col_counter >= MAX_BOUNCE:
			romper()
		
		if col.normal.y == 0:
			velocity.x *= -1
		if col.normal.x == 0:
			velocity.y *= -1
	else:
		velocity.y += GRAVEDAD * delta


func romper():
	drops.drop()
	call_deferred("free")
