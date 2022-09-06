# Hacer una animacion de ataque y cambiar a perseguir
extends State

const SND_MELEE := preload("res://assets/sfx/melee_whiff.wav")

var animador : AnimationPlayer

func enter(msg : Dictionary = {}) -> void:
	owner.input.x = 0
	animador = owner.get_node("Skin/AnimationPlayer")
	
	var rng = randi() % 2
#	animador.play("att" + str(rng + 1))
	animador.play("att1")
	animador.connect("animation_finished", self, "terminar")
	Musica.hacer_sonido(SND_MELEE, owner.global_position)


func terminar(__):
	owner.fsm.transition_to("Perseguir")


func exit() -> void:
	animador.disconnect("animation_finished", self, "terminar")
