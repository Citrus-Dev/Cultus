extends Node
# Mirar al jugador por unos momentos y despues impulsarte en su direccion

const TIEMPO_WINDUP := 0.7
const FUERZA_IMPULSO := 260.0
const FRICCION_OVERRIDE := 0.97
const TIEMPO_PARA_TERMINAR := 0.6
const MINIMA_VELOCIDAD_PARA_TERMINAR := 50.0

var windup : bool
var timer_windup : float
var timer_final : float

func enter(msg : Dictionary = {}) -> void:
	windup = true
	timer_windup = TIEMPO_WINDUP 
	timer_final = TIEMPO_PARA_TERMINAR
	
	owner.aceleracion = FUERZA_IMPULSO
	owner.friccion = FRICCION_OVERRIDE
	owner.max_velocidad_horizontal = FUERZA_IMPULSO
	
	owner.set_animacion("piña_windup")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	if windup:
		timer_windup -= delta
		owner.mirar_al_jugador()
		if timer_windup <= 0:
			windup = false
			owner.input.x = owner.dir
			owner.hurtbox_pignia.is_constant = true
			if determinar_salto(): owner.jump()
	else:
		if owner.animador.current_animation != "piña_real":
			owner.set_animacion("piña_real")
		if owner.input.x != 0: owner.input.x = 0
		if abs(owner.velocity.x) < MINIMA_VELOCIDAD_PARA_TERMINAR: 
			timer_final -= delta
			owner.hurtbox_pignia.is_constant = false
		if timer_final <= 0: 
			owner.determinar_siguiente_ataque()
	
#	owner.set_animacion("piña_windup" if windup else "piña_real")


func physics_process(delta : float) -> void:
	if owner.is_on_floor():
		owner.friccion = FRICCION_OVERRIDE
	else:
		if owner.velocity.y < 0 and diferencia_de_altura_jug() < 0:
			owner.velocity.y *= 0.8
		owner.friccion = 1.0


func exit() -> void:
	owner.valor_default("max_velocidad_horizontal")
	owner.hurtbox_pignia.is_constant = false


func determinar_salto() -> bool:
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	return diferencia_de_altura_jug() > 16.0


func diferencia_de_altura_jug() -> float:
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	return owner.global_position.y - jug.global_position.y

