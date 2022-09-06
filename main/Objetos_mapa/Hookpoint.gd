class_name Hookpoint
extends Node2D

const SND_HOOK := preload("res://assets/sfx/gancho_hookpoint.wav")

onready var anim: AnimationPlayer = get_node("AnimationPlayer")

var activo: bool = true

func usado():
	Musica.hacer_sonido(SND_HOOK, global_position)
	
	anim.play("usar")
	anim.queue("idle")
