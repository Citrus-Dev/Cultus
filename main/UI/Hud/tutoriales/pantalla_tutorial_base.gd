class_name PantTutorialBase
extends CanvasLayer

onready var anim = $AnimationPlayer as AnimationPlayer
var aparicion_terminada : bool

func _ready():
	get_tree().paused = true


func _process(delta):
	if aparicion_terminada and Input.is_action_just_pressed("usar"):
		anim.play("borrar")


func terminar_de_aparecer():
	aparicion_terminada = true


func borrar():
	call_deferred("free")


func _exit_tree():
	get_tree().paused = false

