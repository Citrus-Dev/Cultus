extends State

export(NodePath) onready var steering = get_node(steering) as Steering

var jug 

func enter(msg : Dictionary = {}) -> void:
	if owner.objetivo is Jugador:
		jug = owner.objetivo
	
	add_to_group("EnemigosAlertados")


func physics_process(delta : float) -> void:
	if jug != null:
		var dir_to_player = dir_obj()
		var new_vel = steering.tomar_velocidad(dir_to_player)
		owner.input = new_vel


func exit() -> void:
	return 


func buscar_jug():
	if get_tree().get_nodes_in_group("Jugador").size() > 0:
		jug = get_tree().get_nodes_in_group("Jugador")[0]


func dir_obj() -> Vector2:
	if is_instance_valid(jug):
		return (jug.global_position - owner.global_position).normalized()
	else:
		return Vector2.ZERO
