class_name TriggerOnce
extends Area2D

signal triggered

func _ready() -> void:
	connect("body_entered", self, "trigger")


func trigger(_jug : Jugador):
	emit_signal("triggered")
	call_deferred("free")
