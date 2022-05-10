class_name PlataformaMovible
extends KinematicBody2D

export(NodePath) onready var camino = get_node(camino) as Line2D
export(float) var velocidad 

var path_follow = PathFollow2D.new()
var puntos : PoolVector2Array
var index : int
var velocity : Vector2

func _ready() -> void:
	set("motion/sync_to_physics", true)
	add_child(path_follow)
	puntos = camino.points


func _physics_process(delta: float) -> void:
	var target = puntos[index]
	if global_position.distance_to(target) < 1:
		index = wrapi(index + 1, 0, puntos.size())
		target = puntos[index]
	velocity = (target - global_position).normalized() * velocidad
#	velocity = move_and_slide(velocity)
	global_position += velocity * delta
