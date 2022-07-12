extends State
# Esperar un cierto tiempo de idle. 
# No descontar tiempo si el boss no esta activo (para la intro)

const TIEMPO_DE_ESPERA := 1.3

var timer_espera : float

func enter(msg : Dictionary = {}) -> void:
	owner.set_animacion("idle")
	timer_espera = TIEMPO_DE_ESPERA


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.mirar_al_jugador()
	
	if owner.activo:
		timer_espera -= delta
	
	if timer_espera <= 0:
		owner.determinar_siguiente_ataque()


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 
