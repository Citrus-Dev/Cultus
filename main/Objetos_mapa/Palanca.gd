class_name Palanca
extends Node2D

const PROMPT_VEL_FADE := 2.0

signal activado

onready var area_trigger : Area2D = $Area2D
onready var anim : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

var activado : bool
var shaker := Shaker.new()

func _ready():
	shaker.target = sprite
	shaker.decay = 1
	shaker.max_roll = 0
	shaker.max_offset = Vector2(4, 4)
	add_child(shaker)
	
	area_trigger.connect("body_entered", self, "trigger")


func set_usado():
	anim.play("usado")
	activado = true
	area_trigger.disconnect("body_entered", self, "trigger")


func trigger(__):
	activado = true
	area_trigger.disconnect("body_entered", self, "trigger")
	emit_signal("activado")
	shaker.add_trauma(5)
	anim.play("usar")


