class_name ProyectilHoming
extends ProyectilBase

var target : Personaje

func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	target = get_tree().get_nodes_in_group("Jugador")[0]


func set_velocity():
	if !is_instance_valid(target): return
	var dir_to_target = target.global_position - global_position
	velocity = Vector2.RIGHT.rotated(dir_to_target.angle()).normalized() * move_speed


# En vez de reflejar la borra (reflejar un proyectil homing esta medio dificil)
func reflejar():
	call_deferred("free")
