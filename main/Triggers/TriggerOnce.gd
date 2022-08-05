class_name TriggerOnce
extends Area2D

signal triggered

var _usado : bool setget set_usado

func _ready() -> void:
	connect("body_entered", self, "trigger")


func trigger(_jug : Personaje):
	emit_signal("triggered")
	set_usado(true)


func set_usado(toggle : bool):
	_usado = toggle
	disconnect("body_entered", self, "trigger")
