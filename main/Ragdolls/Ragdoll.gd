class_name Ragdoll
extends Node2D

const LIFETIME := 4.0
const VEL_FADE := 1.0

# Lista de sprites para darlas vuelta
export(Array, NodePath) var sprites

var sprites_lista : Array
var timer_lifetime : float

func _ready() -> void:
	timer_lifetime = LIFETIME
	
	for np in sprites:
		sprites_lista.append(get_node(np))


func set_dir(_dir : int):
	for sprite in sprites_lista:
		sprite = sprite as Sprite
		sprite.flip_h = true if _dir == -1 else false
		sprite.position.x *= _dir


func _process(delta):
	if timer_lifetime > 0:
		timer_lifetime -= delta
	else:
		modulate.a -= delta * VEL_FADE
		if modulate.a <= 0: call_deferred("free")
