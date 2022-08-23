extends State

func enter(msg : Dictionary = {}) -> void:
	owner.animador.connect("animation_finished", self, "salir")
	owner.animador.play("rayo_sans")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.animador.disconnect("animation_finished", self, "salir")


func salir(__:=""):
	owner.fsm.transition_to("DisparoIdle")
