# Castear projectiles con una animacion y volver a Ataque
extends State

func enter(msg : Dictionary = {}) -> void:
	owner.input = Vector2.ZERO
	owner.animador.connect("animation_finished", self, "terminar")
	owner.animador.play("cast")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.animador.disconnect("animation_finished", self, "terminar")
	owner.sprite_circ.visible = false


func terminar(__):
	owner.fsm.transition_to("Ataque")
