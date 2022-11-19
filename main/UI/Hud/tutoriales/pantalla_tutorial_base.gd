class_name PantTutorialBase
extends CanvasLayer

const NOPAUSA_TIEMPO_DESAPARECER: float = 6.0

signal continuado

export(AudioStream) var SONIDO = preload("res://assets/sfx/habilidades.wav")
export var pausar: bool = true

onready var anim = $AnimationPlayer as AnimationPlayer
var aparicion_terminada : bool
var timer: float

func _ready():
	if pausar: 
		get_tree().paused = true
	Musica.hacer_sonido(SONIDO, Vector2.ZERO, 5.0, false)


func _process(delta):
	if anim.current_animation == "borrar":
		return
	
	if pausar:
		process_pausar(delta)
	else:
		process_no_pausar(delta)



func process_pausar(delta: float):
	if aparicion_terminada and Input.is_action_just_pressed("usar"):
		anim.play("borrar")


func process_no_pausar(delta: float):
	timer += delta
	if timer >= NOPAUSA_TIEMPO_DESAPARECER:
		anim.play("borrar")






func terminar_de_aparecer():
	aparicion_terminada = true


func borrar():
	call_deferred("free")


func _exit_tree():
	emit_signal("continuado")
	get_tree().paused = false

