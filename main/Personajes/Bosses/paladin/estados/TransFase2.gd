extends State

func enter(msg : Dictionary = {}) -> void:
	owner.animador.connect("animation_finished", self, "terminar")
	owner.animador.play("fase2")
	owner.fase2_cambiar_color()


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.mirar_al_jugador()


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 


func terminar(__):
	owner.determinar_siguiente_ataque()
	owner.animador.disconnect("animation_finished", self, "terminar")
