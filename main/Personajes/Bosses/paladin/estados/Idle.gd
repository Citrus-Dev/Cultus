extends State
# Esperar un cierto tiempo de idle. 
# No descontar tiempo si el boss no esta activo (para la intro)

const TIEMPO_DE_ESPERA := 1.3
const TIEMPO_DE_ESPERA_2 := 0.7

var timer_espera : float

func enter(msg : Dictionary = {}) -> void:
	timer_espera = TIEMPO_DE_ESPERA if !owner.fase2 else TIEMPO_DE_ESPERA_2


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.mirar_al_jugador()
	
	if owner.is_on_floor():
		if owner.input.x != 0:
			owner.set_animacion("caminar")
		else:
			owner.set_animacion("idle")
	else:
		owner.set_animacion("salto")
	
	if owner.activo:
		timer_espera -= delta
	
	if timer_espera <= 0:
		owner.determinar_siguiente_ataque()


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 
