class_name PantTutorialBase
extends CanvasLayer

const TIEMPO_DESAPARECER: float = 6.0

signal continuado

export(AudioStream) var SONIDO = preload("res://assets/sfx/habilidades.wav")
export var pausar: bool

onready var anim = $AnimationPlayer as AnimationPlayer
var aparicion_terminada : bool

var timer: float

func _ready():
	if pausar:
		get_tree().paused = true
	Musica.hacer_sonido(SONIDO, Vector2.ZERO, 5.0, false)


func _process(delta):
	timer += delta
	
	if pausar:
		process_pausa(delta)
	else:
		process_nao_pausa(delta)


func process_pausa(delta: float):
	if anim.current_animation == "borrar":
		return
	
	if aparicion_terminada and Input.is_action_just_pressed("usar"):
		anim.play("borrar")



func process_nao_pausa(delta: float):
	if anim.current_animation == "borrar":
		return
	
	if aparicion_terminada and timer > TIEMPO_DESAPARECER:
		anim.play("borrar")



func terminar_de_aparecer():
	aparicion_terminada = true


func borrar():
	call_deferred("free")


func _exit_tree():
	emit_signal("continuado")
	get_tree().paused = false

