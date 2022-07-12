extends State
# Moverse lentamente hacia una direccion hasta lo que dure la animacion de girar.
# Quedarse quieto por unos segundos y cambiar de ataque.

const TIEMPO_ESPERA_FINAL := .8

var timer_final : float
var descontando : bool

func enter(msg : Dictionary = {}) -> void:
	owner.set_animacion("giro_loop")
	
	owner.hurtbox_giro.is_constant = true
	owner.input.x = owner.dir
	owner.max_velocidad_horizontal = 120
	
	owner.animador.connect("animation_finished", self, "animacion_terminada")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	if !descontando: return
	
	owner.mirar_al_jugador()
	
	timer_final -= delta
	if timer_final <= 0:
		owner.determinar_siguiente_ataque()


func physics_process(delta : float) -> void:
	var col : KinematicCollision2D = owner.move_and_collide(owner.velocity, true, true, true)
	if col and col.normal.x != 0.0: owner.input.x *= -1


func exit() -> void:
	owner.animador.disconnect("animation_finished", self, "animacion_terminada")
	owner.valor_default("max_velocidad_horizontal")
	descontando = false
	owner.hurtbox_giro.is_constant = false


func animacion_terminada(__):
	owner.set_animacion("idle")
	
	descontando = true
	timer_final = TIEMPO_ESPERA_FINAL
	
	owner.input.x = 0


