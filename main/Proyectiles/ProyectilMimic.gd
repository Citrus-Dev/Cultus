extends ProyectilBase

const VEL_ANGULAR: float = 2.2

export(Color) var color_efecto

var rotador: bool 

func _physics_process(delta: float) -> void:
	set_velocity()
	if rotador:
		rotation += delta * VEL_ANGULAR


func set_velocity():
	velocity = Vector2.RIGHT.rotated(rotation).normalized() * move_speed


func hit():
	var efecto = EfectoCirculo.new(color_efecto, 2.0, 24.0, 0.25)
	efecto.global_position = global_position
	get_tree().root.add_child(efecto)
