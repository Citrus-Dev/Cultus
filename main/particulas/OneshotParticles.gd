class_name OneshotParticles
extends Node2D

var counter : int
var particles := []
var timer := Timer.new()

func _ready() -> void:
	var wait : float
	for child in get_children():
		if child is Particles2D:
			particles.append(child)
			child.one_shot = true
	wait = particles[0].lifetime
	
	add_child(timer)
	timer.wait_time = wait
	timer.one_shot = true
	timer.connect("timeout", self, "finish_playing")
	timer.start()


func finish_playing():
	call_deferred("free")
