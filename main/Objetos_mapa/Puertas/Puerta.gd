class_name Puerta
extends KinematicBody2D

enum EaseType {
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	EASE_OUT_IN 
}

enum TransitionType {
	TRANS_LINEAR,
	TRANS_SINE,
	TRANS_QUINT,
	TRANS_QUART,
	TRANS_QUAD,
	TRANS_EXPO,
	TRANS_ELASTIC,
	TRANS_CUBIC,
	TRANS_CIRC,
	TRANS_BOUNCE,
	TRANS_BACK
}

export(float) var altura_mov = 48
export(float) var tiempo_abrir
export(float) var tiempo_cerrar
export(bool) var empezar_abierto
export(EaseType) var easing_abrir
export(TransitionType) var transicion_abrir
export(EaseType) var easing_cerrar
export(TransitionType) var transicion_cerrar

var pos_cerrado : float
var pos_abierto : float
var abierto : bool
var moving : bool
var tween := Tween.new()

func _ready():
	pos_cerrado = position.y
	pos_abierto = pos_cerrado - altura_mov
	add_child(tween)
	
	if empezar_abierto:
		abierto = true
		position.y = pos_abierto


func abrir():
	if moving:
		return
	
	abierto = true
	moving = true
	tween.interpolate_property(
		self,
		"position:y",
		pos_cerrado,
		pos_abierto,
		tiempo_abrir,
		transicion_abrir,
		easing_abrir
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	moving = false


func cerrar():
	if moving:
		return
	
	moving = true
	tween.interpolate_property(
		self,
		"position:y",
		pos_abierto,
		pos_cerrado,
		tiempo_cerrar,
		transicion_cerrar,
		easing_cerrar
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	abierto = false
	moving = false
