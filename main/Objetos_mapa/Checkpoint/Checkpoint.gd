class_name Checkpoint
extends Node2D

signal usado

onready var area : Area2D = get_node("Area2D")
onready var sprite : Sprite = get_node("Sprite")

var jugador : Jugador
var usando : bool

func _ready() -> void:
	add_to_group("Checkpoints")
	area.connect("body_entered", self, "jug_alternar_area", [true])
	area.connect("body_exited", self, "jug_alternar_area", [false])


func _process(delta: float) -> void:
	if jugador:
		if Input.is_action_just_pressed("usar"):
			alternar_uso_checkpoint(!usando)
	
	var strength = sprite.material.get_shader_param("hit_strength")
	if strength > 0.0:
		sprite.material.set_shader_param("hit_strength", strength - delta)


func guardar_checkpoint(jugador : Jugador):
	var dir_escena_actual : String = get_tree().current_scene.filename
	print(dir_escena_actual + " guardado como checkpoint")
	TransicionesDePantalla.checkpoint_actual_escena = dir_escena_actual
	Guardado.guardar_partida()
	emit_signal("usado")
	ControladorUi.emit_signal("partida_guardada")
	jugador.status.curar()
	
	var nivel = get_tree().get_nodes_in_group("Nivel")[0]
	nivel.guardar_datos_persistentes()


# Alternar la activacion de la zona que te deja usar el checkpoint
func jug_alternar_area(_jug : Jugador, _bool : bool):
	jugador = _jug if _bool else null


# Alternar la activacion del checkpoint en si (sentarse o salir)
func alternar_uso_checkpoint(_bool : bool):
	if !jugador or !jugador.is_on_floor(): 
		return
	if _bool:
		guardar_checkpoint(jugador)
	usando = _bool
	jugador.alternar_checkpoint(_bool)
	if _bool: 
		sprite.material.set_shader_param("hit_strength", 1.0)
		lerp_jug_al_centro()


# Mueve despacito al jugador al centro del checkpoint
func lerp_jug_al_centro():
	var tween := Tween.new()
	add_child(tween)
	
	# global_position + Vector2.UP * 8
	tween.interpolate_property(
		jugador,
		"global_position",
		jugador.global_position,
		global_position,
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	tween.call_deferred("free")
