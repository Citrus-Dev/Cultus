# Se mueve hacia adelante, va spawneando bombas cada tantos segundos
# Si toca una pared desaparece
class_name SpawnerDeHilera
extends KinematicBody2D

const ESCENA_BOMBA := preload("res://main/Personajes/Bosses/bossf/hilera_bombas/BossfBomba.tscn")

const VELOCIDAD: float = 500.0
const INTERVALO_SPAWN: float = 0.1

var velocidad: Vector2
var timer: Timer

func _ready():
	velocidad = (Vector2.RIGHT * VELOCIDAD).rotated(rotation)
	
	timer = Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.wait_time = INTERVALO_SPAWN
	add_child(timer)
	timer.connect("timeout", self, "spawnear_bomba")
	timer.start()



func _physics_process(delta):
	var col = move_and_collide(velocidad * delta)
	if col:
		call_deferred("free")



func spawnear_bomba():
	var spr: Node2D = ESCENA_BOMBA.instance()
	get_parent().add_child(spr)
	spr.global_position = global_position
