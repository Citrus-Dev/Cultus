extends State

const SND_FASE2 := preload("res://assets/sfx/paladin_fase2.wav")

func enter(msg : Dictionary = {}) -> void:
	owner.animador.connect("animation_finished", self, "terminar")
	owner.animador.play("fase2")
	owner.fase2_cambiar_color()
	Musica.hacer_sonido(SND_FASE2, owner.global_position)


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
