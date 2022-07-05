extends State
# Hacer una animacion y al terminar emitir una señal

func enter(msg : Dictionary = {}) -> void:
	owner.animador.play("morir")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 
