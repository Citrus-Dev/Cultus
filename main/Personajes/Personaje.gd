# Superclase para los personajes.
# Tiene variables de movimiento y componentes para el daño y otras cosas.
class_name Personaje
extends KinematicBody2D

const SHADER_HIT = preload("res://assets/shaders/shader_hitcolor.shader")
const KNOCKBACK_FRICCION_HORIZONTAL := 0.4
const KNOCKBACK_FRICCION_VERTICAL := 0.8
const DAMP_AGUA := 500

signal objetivo_encontrado
signal borde_tocado(_borde)
signal muerto
signal muerto_gib

export(bool) var persistir 
export(PackedScene) var ragdoll_escena
export(NodePath) onready var skin = get_node(skin)
export(NodePath) var skin_sprite_path
export(NodePath) onready var status = get_node(status) as Status

export(float) var aceleracion
export(float) var friccion
export(float) var max_velocidad_horizontal
export(float) var max_velocidad_vertical
export(float) var tiempo_stun = 0.6

# Variables de salto
export(float) var jump_height = 96
export(float) var jump_time_to_peak = 0.6
export(float) var jump_time_to_fall = 0.6
export(bool) var no_gravedad 
export(bool) var no_limitar_velocidad

# Ignoren esta matematica la saque de internet ni yo la entiendo.
# Controla la velocidad de saltar.
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
onready var jump_gravity_agua : float = jump_gravity * DAMP_AGUA
onready var fall_gravity_agua : float = fall_gravity * DAMP_AGUA
onready var valores_default := {} # Dict de valores default por si queres cambiar uno temporalmente

var animador : AnimationPlayer
var collider : CollisionShape2D
var hitbox : Hitbox
var behavior_tree : BehaviorTree

var velocity : Vector2
var knockback : Vector2
var knockback_procesable : Vector2
var input : Vector2
var input_override : Vector2
var dir : int setget set_dir # 1 si esta viendo a la derecha, -1 si esta viendo a la izquierda.
var snap : Vector2
var is_jumping : bool
var muerto : bool setget set_muerto
var stun : bool
var objetivo : Personaje # En el caso de los enemigos este es el jugador
var disparando : bool # Para IA
var turning : bool
var is_on_floor : bool
var ciego : bool
var agua : bool

var timer_stun = Timer.new()
var sprites_shader : Array # Lista de sprites que van a ser afectadas por un shader

func _init() -> void:
	add_to_group("Personaje")


func _ready() -> void:
	# Poner las siguientes variables en un lista asi las podemos cambiar y despues volver
	# al valor original (p ej. bajar la friccion durante el stun y despues devolverla)
	set_valores_default([
		"friccion",
		"aceleracion",
		"max_velocidad_horizontal",
		"max_velocidad_vertical",
		"fall_gravity",
		"jump_gravity",
		"jump_velocity"
	])
	init_timer_stun()
	
	animador = get_node("Skin/AnimationPlayer")
	collider = get_node("CollisionShape2D")
	hitbox = get_node("Hitbox")
	
	status.connect("aplicar_dmg", self, "evento_dmg")
	status.connect("morir_info", self, "morir")
	status.connect("aplicar_knockback", self, "aplicar_knockback")
	status.connect("aplicar_stun", self, "aplicar_stun")
	
	cargar_shader_hit()


func _process(delta: float) -> void:
	if muerto:
		if persistir:
			var datos := {"muerto" : true}
			var nivel = get_tree().get_nodes_in_group("Nivel")[0]
			nivel.agregar_dato_persistente(get_path(), datos)
	
	if sprites_shader.size() > 0:
		var fuerza = sprites_shader[0].material.get_shader_param("hit_strength")
		if fuerza == null: return
		
		if fuerza > 0:
			fuerza -= delta * 5
		sprites_shader[0].material.set_shader_param("hit_strength", fuerza)


func _physics_process(delta: float) -> void:
	if stun: input = Vector2.ZERO
	procesar_movimiento(delta)


# LAS FUNCIONES ARRIBA DE ESTO NO SE PUEDEN CAMBIAR EN LAS SUBCLASES
# EN VEZ DE REEMPLAZARLAS SE VAN A EJECUTAR DOS VECES 
# (UNA EN LA SUPERCLASE Y OTRA EN LA SUBCLASE)
# RE CUALQUIERA PERO BUeno un saludo


func procesar_movimiento(_delta : float):
	if muerto: return
	set_snap()
	
	movement_horizontal(_delta)
	velocity = move_and_slide_with_snap(velocity + knockback_procesable, snap, Vector2.UP, true)
	movement_vertical(_delta)
	
	knockback_procesable = Vector2.ZERO
	procesar_knockback()


func movement_horizontal(_delta : float):
	var input_usable = input_override if input_override != Vector2.ZERO else input
	
	if input_usable.x != 0.0:
		velocity.x += aceleracion * input_usable.x
	else:
		velocity.x *= friccion 
	
	if !no_limitar_velocidad:
		velocity.x = clamp(velocity.x, -max_velocidad_horizontal, max_velocidad_horizontal)


func movement_vertical(_delta : float):
	is_on_floor = is_on_floor()
	if !no_gravedad:
		if is_on_floor():
			if is_jumping: is_jumping = false
			velocity.y = 1
		else:
			velocity.y += get_gravity() * _delta
	
	if !no_limitar_velocidad:
		velocity.y = clamp(velocity.y, -max_velocidad_vertical, max_velocidad_vertical)


# Movimiento en las cuatro direcciones (sin gravedad)
func movement_omni():
	var input_usable = input_override if input_override != Vector2.ZERO else input
	if input_usable.x != 0.0:
		velocity.x += aceleracion * input_usable.x
	else:
		velocity.x *= friccion 
	
	if input.y != 0.0:
		velocity.y += aceleracion * input.y
	else:
		velocity.y *= friccion 
	
	if !no_limitar_velocidad:
		velocity.x = clamp(velocity.x, -max_velocidad_horizontal, max_velocidad_horizontal)
		velocity.y = clamp(velocity.y, -max_velocidad_vertical, max_velocidad_vertical)


func procesar_knockback():
	if knockback == Vector2.ZERO:
		return
	
	knockback.x = lerp(knockback.x, 0, KNOCKBACK_FRICCION_HORIZONTAL)
	knockback.y = lerp(knockback.y, 0, KNOCKBACK_FRICCION_VERTICAL)


func aplicar_knockback(_fuerza : float, _dir : Vector2):
	knockback = _dir.normalized() * _fuerza


func set_snap():
	if is_on_floor():
		snap = Vector2.DOWN * 4
	elif !is_jumping:
		snap = Vector2.ZERO


# Da la gravedad correspondiente en base a la matematica flashera de arriba.
func get_gravity() -> float:
	if no_gravedad:
		return 0.0
	if agua:
		return jump_gravity - DAMP_AGUA if velocity.y < 0.0 else fall_gravity - DAMP_AGUA 
	else:
		return jump_gravity if velocity.y < 0.0 else fall_gravity


func set_agua(toggle : bool):
	agua = toggle


func set_dir(_dir : int):
	if _dir != dir:
		turning = true
		animador.play("turn")
	
	dir = _dir
	if _dir != 0: 
		skin.scale.x = _dir


func jump(_jump_vel = jump_velocity):
	is_jumping = true
	snap = Vector2.ZERO
	velocity.y = _jump_vel


func init_timer_stun():
	add_child(timer_stun)
	timer_stun.one_shot = true
	timer_stun.wait_time = tiempo_stun


# durante stun no te podes mover, y se te baja la fricción para que el retroceso te empuje mas
func aplicar_stun(_tiempo_stun := tiempo_stun):
	stun = true
	if !timer_stun.is_stopped():
		timer_stun.stop()
	
	friccion = 0.98
	knockback_procesable = knockback
	efecto_brillo_dmg(2)
	
	# Si el enemigo esta en el aire y no es un enemigo volador le damos mas tiempo
	# de stun (porque lo estas tirando a la mierda y queda medio duro si se recupera
	# en el aire)
	var t : float = _tiempo_stun * 2.4 if !no_gravedad and !is_on_floor() else _tiempo_stun
	timer_stun.start(t)
	yield(timer_stun, "timeout")
	
	valor_default("friccion")
	stun = false


# Llamado cuando recibis daño
func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")


func set_muerto(toggle : bool):
	muerto = toggle
#	collision_mask = 1 # No colisionas con nada mas que el escenario
#	hitbox.collision_layer = 0 # desactiva la hitbox totalmente
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hitbox.set_deferred("monitorable", false)
		hitbox.collision_mask = 0 
	instanciar_ragdoll()
	cambiar_visibilidad(!toggle)


func cambiar_visibilidad(_bool : bool):
	skin.visible = _bool


func instanciar_ragdoll():
	if ragdoll_escena == null:
		return
	var rag = ragdoll_escena.instance() as Ragdoll
	get_parent().add_child(rag)
	rag.global_position = global_position
	rag.set_dir(dir)
	var body = rag.get_child(0) as RigidBody2D
	body.apply_impulse(global_position, velocity)


func set_valores_default(_valores : Array):
	for i in _valores:
		if get(i) == null: continue
		valores_default[i] = get(i)


func valor_default(_valor : String):
	if _valor in valores_default:
		set(_valor, valores_default[_valor])


func cargar_shader_hit():
	if sprites_shader.empty():
		var skin_sprite = get_node(skin_sprite_path)
		if skin_sprite != null:
			sprites_shader.append(skin_sprite)
	
	if skin is Sprite:
		sprites_shader.append(skin)
	else:
		for c in skin.get_children():
			if c is Sprite:
				sprites_shader.append(c)
	
	for sprite in sprites_shader:
		if sprite.material != null: 
			sprite.material = sprite.material.duplicate()
			continue
		var mat = ShaderMaterial.new()
		mat.shader = SHADER_HIT.duplicate(true)
		sprite.material = mat


func efecto_brillo_dmg(_fuerza : float):
	var fuerza_actual = sprites_shader[0].material.get_shader_param("hit_strength")
	if fuerza_actual != null and _fuerza > fuerza_actual:
		for sprite in sprites_shader:
			sprite.material.set_shader_param("hit_strength", _fuerza)


func detectar_borde(_borde):
	emit_signal("borde_tocado", _borde)


func tomar_centro(col_shape : CollisionShape2D = null) -> Vector2:
	if col_shape == null: col_shape = $CollisionShape2D
	var s : RectangleShape2D = col_shape.shape
	return col_shape.global_position


func on_parry(escudo : Node2D):
	var vel_vieja = velocity
	velocity = (global_position - escudo.global_position) * 500
	print(name + ": he sido victima d eparry")
	print("velocidad anterior: " + str(vel_vieja))
	print("velocidad ahora: " + str(velocity))
