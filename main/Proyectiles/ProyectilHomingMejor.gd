class_name ProyectilHomingMejor
extends ProyectilBase

var target : Personaje

func _process(delta):
	set_velocity()


func set_velocity():
	if !is_instance_valid(target): return
	var dir_to_target = target.global_position - global_position
	velocity = Vector2.RIGHT.rotated(dir_to_target.angle()).normalized() * move_speed


