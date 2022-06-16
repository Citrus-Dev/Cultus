# Caminar hacia el jugador, saltando en bordes. 
# Si estas en el suelo y cerca del jugador, cambiar a ataque.
extends State

const TIEMPO_DE_GRACIA := 0.8 # no usar ataques melee hasta despues de este tiempo de empezar a perseguir
const DISTANCIA_DE_ATAQUE := 55.0

var animador : AnimationPlayer
var obj : Jugador
var target_dir : float
var dist : float
var timer_recien_entrado : float

func enter(msg : Dictionary = {}) -> void:
	obj = owner.objetivo 
	animador = owner.get_node("Skin/AnimationPlayer")
	owner.connect("borde_tocado", self, "saltar")
	timer_recien_entrado = TIEMPO_DE_GRACIA


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	calcular_distancia_a_jugador()
	procesar_animacion()
	owner.set_dir(target_dir)
	owner.input.x = target_dir
	
	timer_recien_entrado -= delta
	
	if timer_recien_entrado <= 0 and dist < DISTANCIA_DE_ATAQUE:
		owner.fsm.transition_to("Melee")


func physics_process(delta : float) -> void:
	pass


func exit() -> void:
	return 


func saltar(_borde : Borde):
	# Si el jugador esta por encima del dueño de esta maquina de estados
	if owner.global_position.y > obj.global_position.y:
		owner.jump(owner.jump_velocity * _borde.mult_fuerza_salto)


func calcular_distancia_a_jugador():
	var dir_to_jug = obj.global_position - owner.global_position
	target_dir = sign(dir_to_jug.x)
	dist = abs(dir_to_jug.length())


func procesar_animacion():
	if owner.stun: return
	var velocidad = abs(owner.velocity.x)
	
	if owner.is_on_floor():
		if velocidad > 1:
			animador.play("caminar")
		else:
			animador.play("idle")
	else:
		animador.play("saltar")
