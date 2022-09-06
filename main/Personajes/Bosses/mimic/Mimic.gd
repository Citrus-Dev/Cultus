class_name Mimic
extends Personaje

const PROMPT_COOLDOWN := 1.6
const PROMPT_VEL_FADE := 2.0

const CAST_PISO_DIST := 160.0
const PROYECTIL_ESCENA := preload("res://main/Proyectiles/ProyectilMimic.tscn")

const SND_MIMIC_HIT1 := preload("res://assets/sfx/mimic_hit1.wav")
const SND_MIMIC_HIT2 := preload("res://assets/sfx/mimic_hit2.wav")
const SND_MIMIC_MORIR := preload("res://assets/sfx/mimic_morir.wav")

signal activado

export(NodePath) onready var sprite_inactivo = get_node(sprite_inactivo) as Sprite
export(NodePath) onready var sprite_activo = get_node(sprite_activo) as Sprite
export(NodePath) onready var sprite_laser_impacto = get_node(sprite_laser_impacto) as Sprite
export(NodePath) onready var col = get_node(col) as CollisionShape2D
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var trigger_wake = get_node(trigger_wake) as Area2D
export(NodePath) onready var shaker = get_node(shaker) as Shaker
export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var pos_muerte = get_node(pos_muerte) as Position2D
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var drops = get_node(drops) as DropManager
export(NodePath) onready var snd_sike = get_node(snd_sike) as AudioStreamPlayer

export(NodePath) onready var rc_piso = get_node(rc_piso) as RayCast2D
export(NodePath) onready var rc_izq = get_node(rc_izq) as RayCast2D
export(NodePath) onready var rc_der = get_node(rc_der) as RayCast2D
export(NodePath) onready var rayosnas = get_node(rayosnas) as RayoSans

var balas_dmg: InfoDmg
var activo: bool setget set_activo
var input_actual: int = 1

var jugador : Personaje
var timer_cooldown: Timer
var timer_graciso: Timer
var camara: Camera2D

var dist_del_suelo: float
var dejar_de_disparar: bool
var muerto_enserio: bool
var anim_waking: bool

var prompt_timer : float
var prompt_visible : bool
var tembleque: bool

var contador_drop: int

onready var prompt : Label = get_node("Label")
onready var gibs_escena = preload("res://main/Personajes/Bosses/mimic/gibs_mimic.tscn")
onready var gibs_escena_piedra = preload("res://main/Personajes/Bosses/mimic/gibs_mimic_piedra.tscn")

func _init():
	balas_dmg = InfoDmg.new()
	balas_dmg.dmg_cantidad = 12
	balas_dmg.dmg_tipo = InfoDmg.DMG_TIPOS.PLASMA


func set_activo(toggle: bool):
	activo = toggle
	if activo:
		sprite_activo.visible = true
		sprite_inactivo.visible = false
		
		col.disabled = false
		hurtbox.monitoring = true
		hitbox.call_deferred("set_collision_layer_bit", 5, true)
		
		position.y -= 32.0
		fsm.set_process(true)
		fsm.set_physics_process(true)
		
		fsm.transition_to("DisparoIdle")
	else:
#		trigger_wake.connect("triggered", self, "wake", [], CONNECT_ONESHOT)
		
		sprite_activo.visible = false
		sprite_inactivo.visible = true
		
		col.disabled = true
		hurtbox.monitoring = false
		hitbox.call_deferred("set_collision_layer_bit", 5, false)
		
		fsm.set_process(false)
		fsm.set_physics_process(false)


func _ready():
	timer_cooldown = Timer.new()
	timer_cooldown.one_shot = true
	add_child(timer_cooldown)
	
	timer_graciso = Timer.new()
	timer_graciso.one_shot = true
	add_child(timer_graciso)
	
	set_activo(false)
	prompt.modulate.a = 0.0
	
	trigger_wake.connect("body_entered", self, "jug_alternar_area", [true])
	trigger_wake.connect("body_exited", self, "jug_alternar_area", [false])
	
	reiniciar_contador_drop()


func _process(delta):
	rc_piso.cast_to.y = osciliar(CAST_PISO_DIST, 0.8, 32.0)
	
	if rc_piso.is_colliding():
		dist_del_suelo = global_position.y - rc_piso.get_collision_point().y
		sprite_laser_impacto.position.y = -dist_del_suelo
	
	if !activo and !anim_waking:
		procesar_vis_prompt(delta)
	
	if tembleque:
		procesar_screenshake(delta)


func _physics_process(delta):
	if activo and !muerto: 
		volar(delta)


func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
#	input = Vector2.ZERO


func procesar_screenshake(delta: float):
	if !camara:
		if get_tree().get_nodes_in_group("CamaraReal").size() > 0:
			camara = get_tree().get_nodes_in_group("CamaraReal")[0]
		else:
			return
	
	camara.aplicar_screenshake(2.0)


# Alternar la activacion de la zona que te deja usar el checkpoint
func jug_alternar_area(_jug : Personaje, _bool : bool):
	jugador = _jug if _bool else null


# Llamado cuando recibis daño
func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	check_drops(_dmg.dmg_cantidad)
	
	var snd = get("SND_MIMIC_HIT" + str(randi() % 2 + 1))
	Musica.hacer_sonido(snd, global_position)


func start_wake():
	snd_sike.play()
	
	emit_signal("activado")
	anim_waking = true
	trigger_wake.disconnect("triggered", self, "start_wake")
	efecto_wakeup()
	jugador.aplicar_knockback(1200, (jugador.global_position - global_position))
	prompt.visible = false
	
	timer_graciso.start(1.2)
	yield(timer_graciso, "timeout")
	
	tembleque = true
	
	timer_graciso.start(1.2)
	yield(timer_graciso, "timeout")
	
	tembleque = false
	animador.play("wake")
	
	yield(timer_graciso, "timeout")
	
	animador.play("wake")


func wake():
	instanciar_gibs_piedra()
	barra_hp.setup()
	set_activo(true)


func efecto_wakeup():
	var efec := EfectoCirculo.new(Color.white, 1.0, 196.0, 0.4)
	add_child(efec)


func volar(delta: float):
	input.y = -1 if rc_piso.is_colliding() else 1
	input.x = input_actual
	
	if input_actual == 1 and rc_der.is_colliding():
		input_actual = -1
	elif input_actual == -1 and rc_izq.is_colliding():
		input_actual = 1


func osciliar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x


func hacer_ataque_disparo():
	var funcion: String = "disparar_" + str(randi() % 2 + 1)
	call(funcion)


func procesar_vis_prompt(delta : float):
	prompt_visible = is_instance_valid(jugador) and prompt_timer <= 0
	
	if prompt_timer > 0:
		prompt_timer -= delta
	
	if prompt_visible and prompt.modulate.a < 1.0:
		prompt.modulate.a = min(prompt.modulate.a + delta * PROMPT_VEL_FADE, 1.0)
	if !prompt_visible and prompt.modulate.a > 0.0:
		prompt.modulate.a = max(prompt.modulate.a - delta * PROMPT_VEL_FADE, 0.0)
	
	if prompt_visible and Input.is_action_just_pressed("usar"):
		start_wake()


func disparar_1():
	var p: Node2D = get_tree().get_nodes_in_group("Jugador")[0]
	var contador: int = 16
	var intervalo: float = 0.1
	while contador > 0 and !dejar_de_disparar:
		var bala = PROYECTIL_ESCENA.instance()
		bala.info_dmg = balas_dmg
		bala.rotation = (p.global_position - global_position).angle()
		add_child(bala)
		
		timer_cooldown.start(intervalo)
		yield(timer_cooldown, "timeout")
		
		contador -= 1
	dejar_de_disparar = false


func disparar_2():
	var contador: int = 28
	var intervalo: float = 0.08
	while contador > 0 and !dejar_de_disparar:
		var bala = PROYECTIL_ESCENA.instance()
		bala.info_dmg = balas_dmg
		var rotmod: float = inverse_lerp(0.0, deg2rad(360), contador)
		bala.rotation = (Vector2.DOWN).angle() + rotmod * 3.5
#		bala.rotador = true
		add_child(bala)
		
		timer_cooldown.start(intervalo)
		yield(timer_cooldown, "timeout")
		
		contador -= 1
	dejar_de_disparar = false


func morir(_info : InfoDmg):
	if muerto: return
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	dejar_de_disparar = true
	animador.stop()
	input = Vector2.ZERO
	velocity = Vector2.ZERO
	input_actual = 0
	
	fsm.transition_to("Morir")


func set_muerto(toggle : bool):
	rayosnas.set_activo(false)
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hitbox.set_deferred("monitorable", false)
		hitbox.collision_mask = 0 


func morir_enserio():
	muerto_enserio = true
	
	timer_graciso.start(1.2)
	yield(timer_graciso, "timeout")
	
	emit_signal("muerto")
	cambiar_visibilidad(false)
	
	instanciar_gibs()
	Musica.hacer_sonido(SND_MIMIC_MORIR, global_position)
	
	# anda a cagar no quiero arreglar mas bugs
	call_deferred("free")


func reiniciar_contador_drop():
	contador_drop = status.hp_max / 5


func check_drops(dmg: int):
	contador_drop -= dmg
	if contador_drop <= 0:
		shaker.add_trauma(15.0)
		drops.drop()
		reiniciar_contador_drop()


func instanciar_gibs():
	if gibs_escena == null:
		return
	var gib = gibs_escena.instance() as Gibs
	gib.global_position = global_position
	get_parent().add_child(gib)


func instanciar_gibs_piedra():
	if gibs_escena_piedra == null:
		return
	var gib = gibs_escena_piedra.instance() as Gibs
	gib.global_position = global_position
	get_parent().add_child(gib)
