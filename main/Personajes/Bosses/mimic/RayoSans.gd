class_name RayoSans
extends Node2D

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

var activo: bool setget set_activo

func _ready():
	set_activo(activo)


func set_activo(value: bool):
	activo = value
	visible = activo
	hurtbox.monitoring = value
