class_name GibFisicas
extends KinematicBody2D

const LIFETIME := 4.0
const VEL_FADE := 1.0

export(float) var gravedad
export(float) var friccion
export(float) var vel_rotacion_base

var velocity : Vector2
var vel_rotacion : float
var timer_lifetime : float

func _ready():
	timer_lifetime = LIFETIME
	
	var pos = global_position
	set_as_toplevel(true)
	position = pos


func _process(delta):
	rotation += tomar_radio_de_velocidad() * delta
	
	if timer_lifetime > 0:
		timer_lifetime -= delta
	else:
		modulate.a -= delta * VEL_FADE
		if modulate.a <= 0: call_deferred("free")


func _physics_process(delta):
	velocity.x = lerp(velocity.x, 0, friccion * delta)
	velocity.y += gravedad * delta
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	if col:
		impacto()
		velocity = velocity.bounce(col.normal) * 0.8
		velocity.y *= 0.6


func impacto():
	pass


func tomar_radio_de_velocidad() -> float:
	var vel = velocity.length()
	var r = inverse_lerp(0, vel_rotacion_base, vel)
	return r
