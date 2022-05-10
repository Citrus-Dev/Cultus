# Hace girar un nodo
class_name Rotador
extends Node

export(NodePath) var objeto_path
export(float) var grados_por_seg

var objeto : Node2D

func _ready() -> void:
	if objeto_path != "":
		objeto = get_node(objeto_path)
	else:
		objeto = get_parent()


func _process(delta: float) -> void:
	objeto.rotation += deg2rad(grados_por_seg) * delta
