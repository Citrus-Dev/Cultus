class_name Slide
extends Habilidad

const ESCENA_MEDIDOR_COOLDOWN = preload("res://main/UI/Hud/MedidorCooldown.tscn")
const TEXTURA_ICONO = preload("res://assets/ui/IconoHUDPiedra.tres")

const TIEMPO_COOLDOWN := 0.8

signal cooldown_update(valor)

export(float) var velocidad
export(float) var tiempo

var timer := Timer.new()
var timer_cooldown := Timer.new()

func _ready():
	timer_cooldown.wait_time = TIEMPO_COOLDOWN
	timer_cooldown.one_shot = true
	add_child(timer_cooldown)
	
	timer.wait_time = tiempo
	timer.one_shot = true
	add_child(timer)
	
	yield(get_tree(), "idle_frame")
	instanciar_medidor_cooldown()


func _process(delta):
	emit_signal("cooldown_update", timer_cooldown.time_left)


func _physics_process(delta):
	if !timer.is_stopped() and jugador.is_on_floor():
		if Input.is_action_just_pressed("mov_arr"):
			jugador.salto_largo()


func detectar_usable():
	contexto_usable = jugador.input.x != 0.0 and jugador.is_on_floor()
	contexto_usable = contexto_usable and timer_cooldown.is_stopped()


func detectar_activacion(delta):
	if Input.is_action_just_pressed("mov_abaj"):
		activar()


func activar():
	timer_cooldown.start()
	
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


func instanciar_medidor_cooldown():
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	var inst = ESCENA_MEDIDOR_COOLDOWN.instance()
	hud.instanciar_medidor_cooldown(inst)
	inst.set_icono_textura(TEXTURA_ICONO)
	inst.set_color(Color.lightblue)
	inst.progress_bar.max_value = TIEMPO_COOLDOWN
	connect("cooldown_update", inst, "actualizar_valor")

