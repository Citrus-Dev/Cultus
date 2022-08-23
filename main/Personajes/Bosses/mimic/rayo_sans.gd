extends Node2D

onready var rc: RayCast2D = $RayCast2D

var activo: bool setget set_activo

func set_activo(toggle: bool):
	rc.enabled = toggle
