class_name PlataformaMovible
extends KinematicBody2D

export(NodePath) onready var camino = get_node(camino) as Line2D
export(float) var velocidad 
export(bool) var solo_pisando

var path_follow = PathFollow2D.new()
var puntos : PoolVector2Array
var index : int
var velocity : Vector2
var pisando : bool
var pisado_una_vez : bool

func _ready() -> void:
	set("motion/sync_to_physics", true)
	add_child(path_follow)
	puntos = camino.points
	camino.visible = false
	global_position = puntos[0]


func _physics_process(delta: float) -> void:
	if !pisado_una_vez and pisando:
		pisado_una_vez = true
	
	if solo_pisando and !pisado_una_vez: return
	
	var target = puntos[index]
	if global_position.distance_to(target) < 1:
		index = wrapi(index + 1, 0, puntos.size())
		target = puntos[index]
	velocity = (target - global_position).normalized() * velocidad
#	velocity = move_and_slide(velocity)
	global_position += velocity * delta
