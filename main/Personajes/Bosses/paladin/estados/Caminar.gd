extends State
# Caminar mirando hacia el jugador. 
# Quedarse quieto por unos segundos y cambiar de ataque.

const TIEMPO_DE_CAMINAR := 1.8
const TIEMPO_ESPERA_FINAL := 0.7

var timer : float

var timer_final : float
var descontando : bool

func enter(msg : Dictionary = {}) -> void:
	descontando = false
	timer = TIEMPO_DE_CAMINAR
	timer_final = TIEMPO_ESPERA_FINAL
	
	owner.set_animacion("caminar")
	owner.input.x = owner.dir


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.mirar_al_jugador()
	
	if !descontando:
		timer -= delta
		if timer <= 0: terminar_de_moverse()
		return
	
	timer_final -= delta
	if timer_final <= 0:
		owner.determinar_siguiente_ataque()


func physics_process(delta : float) -> void:
	var col : KinematicCollision2D = owner.move_and_collide(owner.velocity, true, true, true)
	if col and col.normal.x != 0.0: owner.input.x *= -1


func exit() -> void:
	return 


func terminar_de_moverse():
	owner.input.x = 0
	descontando = true
	owner.set_animacion("idle")
