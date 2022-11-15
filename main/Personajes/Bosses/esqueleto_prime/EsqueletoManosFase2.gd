class_name ManosDeMierdaMaggiForro
extends Node2D

const INTERVALO: float = 2.5

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer

var timer: float
var muerto: bool
var activado: bool
var atacando: bool



func _ready():
	anim.connect("animation_finished", self, "evento_anim_terminada")


func evento_anim_terminada():
	if muerto: return
	
	if !activado:
		activado = true
	anim.play("idle")



func _process(delta):
	if muerto or !activado:
		return
	
	timer += delta
	if timer > INTERVALO:
		elegir_ataque_random()



func activar():
	anim.play("activar")


func elegir_ataque_random():
	timer = 0




func esquele_muerto():
	muerto = true
	anim.play("muerte")










