class_name PickupLlaveIglesia
extends KinematicBody2D

const MAX_VEL := 1500.0
const GRAVEDAD := 500.0
const BOUNCE_DAMP := 0.6

onready var area: Area2D = $Area2D

var velocity: Vector2

func _ready():
	area.connect("body_entered", self, "pickup")


func pickup(__):
	ControladorUi.mensaje_ui("Esta llave abre las puertas de la iglesia.", 5.0, true)
	TransicionesDePantalla.tiene_llave_iglesia = true
	
	call_deferred("free")


func _physics_process(delta):
	velocity.y += GRAVEDAD * delta
	velocity.y = clamp(velocity.y, -MAX_VEL, MAX_VEL)
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity.y = -velocity.y * BOUNCE_DAMP









