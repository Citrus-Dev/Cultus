extends State

# Tiempo de esperar antes de disparar
export(float) var tiempo_de_disparo = 0.5
# Tiempo de esperar antes de volver al estado perseguir
export(float) var tiempo_de_espera = 0.3
export(NodePath) onready var controlador_armas = get_node(controlador_armas) as ControladorArmasNPC
export(int) var rafaga

var timer := Timer.new()
var jug : Jugador
var animador : AnimationPlayer

func _ready():
	add_child(timer)
	timer.one_shot = true


func enter(msg : Dictionary = {}) -> void:
	owner.input.x = 0.0
	if owner.objetivo is Jugador:
		jug = owner.objetivo
	controlador_armas.target_obj = jug
	animador = owner.skin.get_node("AnimationPlayer")
	
	timer.connect("timeout", self, "empezar_a_disparar")
	timer.start(tiempo_de_disparo)
	animador.play("idle")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	controlador_armas.target_obj = null
	controlador_armas.input_disparar = 0
	controlador_armas.disconnect("termino_de_disparar", self, "terminar_de_disparar")
	timer.disconnect("timeout", self, "empezar_a_disparar")
	timer.disconnect("timeout", self, "salir_del_estado")


func empezar_a_disparar():
	timer.disconnect("timeout", self, "empezar_a_disparar")
	controlador_armas.input_disparar = rafaga
	controlador_armas.connect("termino_de_disparar", self, "terminar_de_disparar")


func terminar_de_disparar():
	controlador_armas.disconnect("termino_de_disparar", self, "terminar_de_disparar")
	timer.start(tiempo_de_espera)
	timer.connect("timeout", self, "salir_del_estado")


func salir_del_estado():
	timer.disconnect("timeout", self, "salir_del_estado")
	_state_machine.transition_to("Perseguir")
