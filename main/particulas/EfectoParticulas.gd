class_name EfectoParticulas
extends Node2D

var efecto : Particles2D
var timer : float

func _ready():
	if get_child(0) != null: efecto = get_child(0)
	efecto.emitting = true
	timer = efecto.lifetime


func _process(delta):
	timer -= delta
	if timer <= 0: terminar_efecto()


func terminar_efecto():
	call_deferred("free")
