class_name Hookpoint
extends Node2D

onready var anim: AnimationPlayer = get_node("AnimationPlayer")

var activo: bool = true

func usado():
	anim.play("usar")
	anim.queue("idle")
