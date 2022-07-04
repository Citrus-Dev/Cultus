extends Node2D

export(float) var tiempo = 0.1

func _ready():
	set_as_toplevel(true)
	yield(get_tree().create_timer(tiempo), "timeout")
	call_deferred("free")
