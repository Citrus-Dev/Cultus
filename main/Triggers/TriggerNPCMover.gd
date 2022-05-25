# Fuerza a un NPC a moverse en una direccion mientras toca esto
class_name TriggerNPCMover
extends Area2D

export(Vector2) var dir

func _ready():
	connect("body_entered", self, "enemigo_entrado")
	connect("body_exited", self, "enemigo_salido")


func enemigo_entrado(body : Personaje):
	body.input_override = dir


func enemigo_salido(body : Personaje):
	body.input_override = Vector2.ZERO
