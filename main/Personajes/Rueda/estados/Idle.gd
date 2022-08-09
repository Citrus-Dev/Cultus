# No hacer nada hasta ser alertado
extends State

func enter(msg : Dictionary = {}) -> void:
	owner.connect("objetivo_encontrado", self, "alertar")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 


func alertar():
	if !owner.ciego:
		_state_machine.transition_to("Perseguir")
