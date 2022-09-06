class_name Checkpoint
extends Node2D

# El mensaje "E para guardar" no se va a mostrar por este tiempo despues de usar el checkpoint
const PROMPT_COOLDOWN := 1.6
const PROMPT_VEL_FADE := 2.0
const SONIDO := preload("res://assets/sfx/checkopointo v1.wav")

signal usado

onready var area : Area2D = get_node("Area2D")
onready var sprite : Sprite = get_node("Sprite")
onready var prompt : Label = get_node("Label")

var jugador : Personaje
var usando : bool
var prompt_timer : float
var prompt_visible : bool

func _ready() -> void:
	add_to_group("Checkpoints")
	area.connect("body_entered", self, "jug_alternar_area", [true])
	area.connect("body_exited", self, "jug_alternar_area", [false])
	prompt.modulate.a = 0.0


func _process(delta: float) -> void:
	procesar_vis_prompt(delta)
	
	if jugador:
		if Input.is_action_just_pressed("usar"):
			alternar_uso_checkpoint(!usando)
	
	var strength = sprite.material.get_shader_param("hit_strength")
	if strength > 0.0:
		sprite.material.set_shader_param("hit_strength", strength - delta)


func procesar_vis_prompt(delta : float):
	prompt_visible = is_instance_valid(jugador) and prompt_timer <= 0
	
	if usando: prompt_timer = PROMPT_COOLDOWN
	
	if prompt_timer > 0:
		prompt_timer -= delta
	
	if prompt_visible and prompt.modulate.a < 1.0:
		prompt.modulate.a = min(prompt.modulate.a + delta * PROMPT_VEL_FADE, 1.0)
	if !prompt_visible and prompt.modulate.a > 0.0:
		prompt.modulate.a = max(prompt.modulate.a - delta * PROMPT_VEL_FADE, 0.0)


func guardar_checkpoint(jugador : Personaje):
	var dir_escena_actual : String = get_tree().current_scene.filename
	print(dir_escena_actual + " guardado como checkpoint")
	TransicionesDePantalla.checkpoint_actual_escena = dir_escena_actual
	TransicionesDePantalla.checkpoint_actual_pos = global_position
	Guardado.guardar_partida()
	emit_signal("usado")
	ControladorUi.emit_signal("mensaje_ui", "Partida guardada", 2.5)
	Musica.hacer_sonido(SONIDO, global_position, 2.0)
	jugador.status.curar()
	
	var nivel = get_tree().get_nodes_in_group("Nivel")[0]
	nivel.guardar_datos_persistentes()


# Alternar la activacion de la zona que te deja usar el checkpoint
func jug_alternar_area(_jug : Personaje, _bool : bool):
	jugador = _jug if _bool else null
#	if prompt_timer > 0: prompt_visible = false


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
