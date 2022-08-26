class_name Mimic
extends Personaje

const CAST_PISO_DIST := 160.0
const PROYECTIL_ESCENA := preload("res://main/Proyectiles/ProyectilMimic.tscn")

export(NodePath) onready var sprite_inactivo = get_node(sprite_inactivo) as Sprite
export(NodePath) onready var sprite_activo = get_node(sprite_activo) as Sprite
export(NodePath) onready var sprite_laser_impacto = get_node(sprite_laser_impacto) as Sprite
export(NodePath) onready var col = get_node(col) as CollisionShape2D
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var trigger_wake = get_node(trigger_wake) as TriggerOnce
export(NodePath) onready var shaker = get_node(shaker) as Shaker
export(NodePath) onready var fsm = get_node(fsm) as StateMachine

export(NodePath) onready var rc_piso = get_node(rc_piso) as RayCast2D
export(NodePath) onready var rc_izq = get_node(rc_izq) as RayCast2D
export(NodePath) onready var rc_der = get_node(rc_der) as RayCast2D

var balas_dmg: InfoDmg
var activo: bool setget set_activo
var input_actual: int = 1

var timer_cooldown: Timer
var dist_del_suelo :float

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
		hitbox.set_collision_layer_bit(32, true)
		
		position.y -= 32.0
		fsm.set_process(true)
		fsm.set_physics_process(true)
		
		fsm.transition_to("DisparoIdle")
	else:
		trigger_wake.connect("triggered", self, "wake", [], CONNECT_ONESHOT)
		
		sprite_activo.visible = false
		sprite_inactivo.visible = true
		
		col.disabled = true
		hurtbox.monitoring = false
		hitbox.set_collision_layer_bit(32, false)
		
		fsm.set_process(false)
		fsm.set_physics_process(false)


func _ready():
	timer_cooldown = Timer.new()
	timer_cooldown.one_shot = true
	add_child(timer_cooldown)
	
	set_activo(false)


func _draw():
	draw_line(Vector2.ZERO, input * 32.0, Color.green, 3.0)


func _process(delta):
	update()
	rc_piso.cast_to.y = osciliar(CAST_PISO_DIST, 0.8, 32.0)
	
	if rc_piso.is_colliding():
		dist_del_suelo = global_position.y - rc_piso.get_collision_point().y
		sprite_laser_impacto.position.y = -dist_del_suelo


func _physics_process(delta):
	if activo: volar(delta)


func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	input = Vector2.ZERO


func start_wake():
	trigger_wake.disconnect("triggered", self, "start_wake")
	efecto_wakeup()
	animador.play("wake")


func wake():
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


func disparar_1():
	var p: Node2D = get_tree().get_nodes_in_group("Jugador")[0]
	var contador: int = 16
	var intervalo: float = 0.1
	while contador > 0:
		var bala = PROYECTIL_ESCENA.instance()
		bala.info_dmg = balas_dmg
		bala.rotation = (p.global_position - global_position).angle()
		add_child(bala)
		
		timer_cooldown.start(intervalo)
		yield(timer_cooldown, "timeout")
		
		contador -= 1


func disparar_2():
	var contador: int = 28
	var intervalo: float = 0.08
	while contador > 0:
		var bala = PROYECTIL_ESCENA.instance()
		bala.info_dmg = balas_dmg
		var rotmod: float = inverse_lerp(0.0, deg2rad(360), contador)
		bala.rotation = (Vector2.DOWN).angle() + rotmod * 3.5
#		bala.rotador = true
		add_child(bala)
		
		timer_cooldown.start(intervalo)
		yield(timer_cooldown, "timeout")
		
		contador -= 1

