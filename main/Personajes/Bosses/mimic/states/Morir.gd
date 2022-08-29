extends State

func enter(msg : Dictionary = {}) -> void:
	owner.input = Vector2.ZERO


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.shaker.add_trauma(0.5)


func physics_process(delta : float) -> void:
	
	owner.global_position.x = lerp(owner.global_position.x, owner.pos_muerte.global_position.x, delta * 1.0)
	owner.global_position.y = lerp(owner.global_position.y, owner.pos_muerte.global_position.y, delta * 1.0)
	
	var dist: float = abs((owner.global_position - owner.pos_muerte.global_position).length())
	if dist < 6.0:
		owner.morir_enserio()


func exit() -> void:
	return 
