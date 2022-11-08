class_name Casquillo
extends KinematicBody2D

const SONIDO: AudioStream = preload("res://assets/sfx/armas/shells_hit.wav")
const DAMP_X := 0.99
const DAMP_X_GROUNDED := 0.8
const GRAVEDAD := 1000.0
const LIFETIME := 3
const RAND_ANGULO := 5.0
const RAND_FUERZA := 60.0
const BOUNCE_DAMP := 0.65

export(float) var extra_lifetime

var max_vel_y := -50
var vel_dir : Vector2 = Vector2.RIGHT
var fuerza : float

var velocity : Vector2
var contador_lifetime : float
var sprite_rot : float
var flip : int # 1 si se disparó mirando a la derecha, -1 si es a la izquierda

onready var angular_velocity : float = rand_range(2, 15)
onready var sprite = get_node("Sprite")

export(Curve) var curva_fade

func _ready() -> void:
	fuerza += rand_range(-RAND_FUERZA, RAND_FUERZA)
	var ang := deg2rad(rand_range(-RAND_ANGULO, RAND_ANGULO))
	vel_dir = vel_dir.rotated(ang)
	
	var pos = global_position
	set_as_toplevel(true)
	global_position = pos
	
	sprite_rot = vel_dir.angle()
	velocity = vel_dir * fuerza
	contador_lifetime = LIFETIME + extra_lifetime


func _process(delta: float) -> void:
	proceso(delta)


func proceso(delta : float):
	if is_in_group("CuerposEnAgua"):
		modulate = Color.black
	else:
		modulate = Color.white
	
	if contador_lifetime < LIFETIME:
		modulate.a = curva_fade.interpolate(contador_lifetime / LIFETIME)
	
	if !is_on_floor():
		sprite_rot -= (angular_velocity * delta) * flip
		sprite.rotation = sprite_rot
	
	contador_lifetime -= delta
	if contador_lifetime <= 0:
		call_deferred("free")


func _physics_process(delta: float) -> void:
	var pre_vel = velocity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x *= DAMP_X_GROUNDED if is_on_floor() else DAMP_X
	velocity.y += GRAVEDAD * delta
	
	if is_in_group("CuerposEnAgua"):
		velocity.x = clamp(velocity.x, -50, 50)
		velocity.y = clamp(velocity.y, max_vel_y, 50)
		velocity.x *= 0.9
	
	if max_vel_y < -5:
		if get_slide_count() > 0:
			var collision = get_slide_collision(0)
			var norm = collision.normal
			velocity = pre_vel.bounce(collision.normal) * BOUNCE_DAMP
			max_vel_y *= BOUNCE_DAMP
			Musica.hacer_sonido(SONIDO, global_position)
	elif is_on_floor() and !is_on_wall() or is_in_group("CuerposEnAgua"):
		set_physics_process(false)


func set_sprite(_spr : Texture):
	sprite.texture = _spr
