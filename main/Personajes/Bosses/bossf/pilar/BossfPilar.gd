class_name BossfPilar
extends Node2D


const TIEMPO_TELEGRAFEAR: float = 1.5 # lo que duran las particulas antes de subir
const TIEMPO_SUBIDA_BAJADA: float = 0.2 # lo que tarda en terminar de subir/bajar con el tween
const TIEMPO_ESPERA_ARRIBA: float = 1.5 # lo que queda esperando arriba antes de bajar


export(NodePath) onready var eje = get_node(eje) as Node2D
export(NodePath) onready var particulas = get_node(particulas) as Particles2D
export(NodePath) onready var anim = get_node(anim) as AnimationPlayer
export var animar: bool


var timer_espera: Timer
var tween: Tween

var activo: bool


onready var altura_inicial = eje.global_position.y


func _init():
	add_to_group("bossf_pilares")


func _ready():
	timer_espera = Timer.new()
	timer_espera.one_shot = true
	add_child(timer_espera)
	
	tween = Tween.new()
	add_child(tween)



func activar():
	if activo:
		return
	activo = true
	
	
	if !animar:
		
		# telegrafear con los efectos de particulas
		particulas.emitting = true
		timer_espera.start(TIEMPO_TELEGRAFEAR)
		yield(timer_espera, "timeout")
		particulas.emitting = false
		
		
		# Moverse para arriba, esperar
		tween.interpolate_property(
			eje,
			"position:y",
			altura_inicial,
			0.0,
			TIEMPO_SUBIDA_BAJADA,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT
		)
		tween.start()
		yield(tween, "tween_all_completed")
		
		
		timer_espera.start(TIEMPO_ESPERA_ARRIBA)
		yield(timer_espera, "timeout")
		
		
		# Volverse para abajo
		tween.interpolate_property(
			eje,
			"position:y",
			0.0,
			altura_inicial,
			TIEMPO_SUBIDA_BAJADA,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT
		)
		tween.start()
		yield(tween, "tween_all_completed")
		
	else:
		
		# telegrafear con los efectos de particulas
		particulas.emitting = true
		anim.play("telegraph")
		timer_espera.start(TIEMPO_TELEGRAFEAR)
		yield(timer_espera, "timeout")
		particulas.emitting = false
		
		anim.play("ouch")
		yield(anim, "animation_finished")
	
	activo = false
