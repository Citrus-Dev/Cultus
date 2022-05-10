class_name Ragdoll
extends Node2D

# Lista de sprites para darlas vuelta
export(Array, NodePath) var sprites

var sprites_lista : Array

func _ready() -> void:
	for np in sprites:
		sprites_lista.append(get_node(np))


func set_dir(_dir : int):
	for sprite in sprites_lista:
		sprite = sprite as Sprite
		sprite.flip_h = true if _dir == -1 else false
