class_name Slide
extends Habilidad

export(float) var velocidad
export(float) var tiempo

var timer := Timer.new()

func _ready():
	timer.wait_time = tiempo
	timer.one_shot = true
	add_child(timer)


func _physics_process(delta):
	if !timer.is_stopped() and jugador.is_on_floor():
		if Input.is_action_just_pressed("mov_arr"):
			jugador.salto_largo()


func detectar_usable():
	contexto_usable = jugador.input.x != 0.0 and jugador.is_on_floor()


func detectar_activacion(delta):
	if Input.is_action_just_pressed("mov_abaj"):
		activar()


func activar():
	jugador.set_dir(sign(jugador.input.x))
	jugador.turning = false
	jugador.usando_habilidad = true
	jugador.max_velocidad_horizontal = velocidad
	jugador.input.x = velocidad * sign(jugador.input.x)
	jugador.animador.play("slide_start")
	
	timer.start()
	yield(timer, "timeout")
	
	jugador.usando_habilidad = false
	jugador.valor_default("max_velocidad_horizontal")
	
	# Manualmente reactivamos la hitbox porque la animacion RESET no lo hace por alguna razon.
	var hb : Hitbox = jugador.get_node("Hitbox")
	hb.monitorable = true
	hb.monitoring = true
