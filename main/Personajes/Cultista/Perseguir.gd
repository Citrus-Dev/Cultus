extends State

# Va a esperar un tiempo random entre estos dos numeros antes de disparar
export(Vector2) var intervalo_disparo = Vector2(0.4, 1.2)
export(NodePath) onready var los_check = get_node(los_check) as LOSCheck

var timer_disparo := Timer.new()
var obj_jug : Jugador
var animador : AnimationPlayer

var debug_timer

func _ready():
	add_child(timer_disparo)
	timer_disparo.one_shot = true


func enter(msg : Dictionary = {}) -> void:
	timer_disparo.connect("timeout", self, "terminar_timer_disparo")
	owner.connect("borde_tocado", self, "saltar")
	if owner.objetivo is Jugador:
		obj_jug = owner.objetivo
	iniciar_timer_disparo()
	
	animador = owner.skin.get_node("AnimationPlayer")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	debug_timer = timer_disparo.time_left
	if !owner.turning:
		if !owner.stun:
			if owner.is_on_floor():
				animador.play("correr")
			else:
				if owner.velocity.y > 0:
					animador.play("caer")
				else:
					animador.play("saltar")
		else:
			animador.play("hurt")


func physics_process(delta : float) -> void:
	if is_instance_valid(obj_jug):
		owner.dir = sign(owner.global_position.direction_to(obj_jug.global_position).x)
		owner.input.x = owner.dir
	else:
		_state_machine.transition_to("Patrullar")


func exit() -> void:
	owner.disconnect("borde_tocado", self, "saltar")
	timer_disparo.disconnect("timeout", self, "terminar_timer_disparo")


func saltar(_borde : Borde):
	# Si el jugador esta por encima del dueño de esta maquina de estados
	if owner.global_position.y > obj_jug.global_position.y:
		owner.jump(owner.jump_velocity * _borde.mult_fuerza_salto)


func iniciar_timer_disparo():
	timer_disparo.stop()
	timer_disparo.wait_time = rand_range(intervalo_disparo.x, intervalo_disparo.y)
	timer_disparo.start()


# revisar si el jugador esta dentro del rango de disparo y tiene linea de vision.
# Si eso es verdadero, pasar al estado disparar
func terminar_timer_disparo():
	if owner.stun: return
	for obj in los_check.obj_en_vision:
		if obj is Jugador and owner.is_on_floor():
			_state_machine.transition_to("Disparar")
			return
	iniciar_timer_disparo()


