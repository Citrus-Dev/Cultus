class_name PiedraBossF
extends KinematicBody2D

const GRAVEDAD: float = 250.0
const VEL_ROTACION: float = 30.0
const CHANCE_DROP: int = 7 # Chance de 1 en X


onready var sprite: Sprite = $Sprite
onready var drops: DropManager = $DropManager


func _process(delta):
	sprite.rotation += VEL_ROTACION * delta


func _physics_process(delta):
	var kc := move_and_collide( Vector2.DOWN * GRAVEDAD * delta )
	if kc:
		call_deferred("free")
		if randi() % CHANCE_DROP == 0:
			drops.drop()
