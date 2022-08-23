extends State

var veces: int
var contador: int

func enter(msg : Dictionary = {}) -> void:
	randomize()
	# Cuantas veces vamos a repetir la animacion antes de elegir un ataque
	veces = randi() % 3 + 1
	contador = veces
	owner.animador.connect("animation_finished", self, "repetir_animacion_o_salir")
	repetir_animacion_o_salir("")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.animador.disconnect("animation_finished", self, "repetir_animacion_o_salir") 


func repetir_animacion_o_salir(__):
	contador -= 1
	if contador < 0:
		randomize()
		var rng = randi() % 1
		match rng:
			0:
				owner.fsm.transition_to("RayoSans")
				return
			1:
				owner.fsm.transition_to("Embestida")
				return
	owner.animador.play("disparo_idle")
