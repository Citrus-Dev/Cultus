class_name ProyectilHomingMejor
extends ProyectilBase

var target : Personaje

func _process(delta):
	set_velocity()


func set_velocity():
	if !is_instance_valid(target): return
	var dir_to_target = target.global_position - global_position
	velocity += Vector2.RIGHT.rotated(dir_to_target.angle()).normalized() * move_speed


func reflejar():
	velocity = -velocity


func hit():
	var efecto := EfectoCirculo.new(
		$EstelaBase.gradient.colors[1],
		0.0,
		32.0,
		0.35
	)
	get_tree().root.add_child(efecto)
	efecto.global_position = global_position
