extends State
# Saltar hacia el jugador con una fuerza horizontal random.

const TIEMPO_ESPERA_FINAL := 0.8
const TIEMPO_ESPERA_FINAL_2 := 0.4
const VARIACION_MOV_H := [60.0, 120.0]

signal aterrizado

var tiempo_a_terminar_salto : float

var esperando : bool
var timer_final : float

func enter(msg : Dictionary = {}) -> void:
	owner.set_animacion("salto")
	owner.mirar_al_jugador()
	
	var espera = TIEMPO_ESPERA_FINAL if !owner.fase2 else TIEMPO_ESPERA_FINAL_2
	tiempo_a_terminar_salto = owner.jump_time_to_peak + owner.jump_time_to_fall + espera
	timer_final = tiempo_a_terminar_salto
	
	owner.max_velocidad_horizontal = rand_range(VARIACION_MOV_H[0], VARIACION_MOV_H[1])
	owner.input.x = owner.dir
	owner.jump()


func process(delta : float) -> void:
	timer_final -= delta
	if timer_final <= 0:
		owner.determinar_siguiente_ataque()


func physics_process(delta : float) -> void:
	var col : KinematicCollision2D = owner.move_and_collide(owner.velocity, true, true, true)
	if col and col.normal.x != 0.0: owner.input.x *= -1
	
	if owner.animador.current_animation == "salto" and owner.is_on_floor():
		emit_signal("aterrizado")
		owner.set_animacion("idle")
		owner.input.x = 0
		esperando = true
		owner.mirar_al_jugador()


func exit() -> void:
	esperando = false
	owner.valor_default("max_velocidad_horizontal")
