# Inclinarse a medida que el ugador hace fuerza para un lado
# Cuando llegue a un maximo de tension, romper la cadena y bajar la jaula
# TODO hacer trigger que mande una señal cuando el jugador empuja en una direccion
# TODO hacer que un gib se pueda poner inactivo y despues activar (para la cadena)
class_name IntroJaula
extends Node2D

const MAX_TENSION := 8
const COOLDOWN_AREA_SALTO := 0.5
const VEL_CAIDA := 350.0

signal caida_empezada

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer
export(NodePath) onready var area_salto = get_node(area_salto) as Area2D
export(NodePath) onready var jaula = get_node(jaula) as KinematicBody2D
export(NodePath) onready var rc = get_node(rc) as RayCast2D

var tension: int
var cayendo: bool
var caido: bool

var timer_cooldown_salto : float

var shaker := Shaker.new()

func _ready():
	area_salto.connect("body_entered", self, "detectar_salto")
	
	shaker.target = jaula
	shaker.decay = 1
	shaker.max_roll = 0
	shaker.max_offset = Vector2(6, 6)
	add_child(shaker)


func _process(delta):
	if timer_cooldown_salto > 0:
		timer_cooldown_salto -= delta


func _physics_process(delta):
	if cayendo:
#		jaula.move_and_collide(Vector2.DOWN * VEL_CAIDA * delta)
		jaula.global_position += Vector2.DOWN * VEL_CAIDA * delta
		if rc.is_colliding():
			terminar_de_caer()


func aumentar_tension():
	tension += 1
	shaker.add_trauma(0.6)
	if tension >= MAX_TENSION:
		caer()
		shaker.add_trauma(6.0)


func caer():
	anim.stop()
	area_salto.disconnect("body_entered", self, "detectar_salto")
	cayendo = true
	emit_signal("caida_empezada")


func terminar_de_caer():
	jaula.call_deferred("free")
	
	cayendo = false
	caido = true


func detectar_salto(jug: Personaje):
	if timer_cooldown_salto > 0: 
		return
	
	if jug.velocity.y > 0:
		timer_cooldown_salto = COOLDOWN_AREA_SALTO
		aumentar_tension()
