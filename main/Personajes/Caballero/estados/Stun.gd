extends State

export(String) var estado_salida

var dir : Vector2
var timer : float

func enter(msg : Dictionary = {}) -> void:
	if msg.has("Tiempo"):
		timer = msg["Tiempo"]
	
	if msg.has("Dir"):
		dir = msg["Dir"]
	
	owner.velocity = dir
	owner.no_limitar_velocidad = true


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	timer -= delta
	if timer <= 0:
		_state_machine.transition_to(estado_salida)


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.no_limitar_velocidad = false
