class_name ExplFlash
extends Node2D

export(NodePath) var path_collider 
export(float) var radio_comienzo = 32
export(float) var radio_final = 256
export(float) var duracion = 0.8

var collider : CollisionShape2D
var shape : CircleShape2D
var tween : Tween

var alpha := 1.0

func _ready():
	$Area2D.connect("body_entered", self, "enemigo_detectado")
	
	collider = get_node(path_collider)
	shape = collider.shape
	
	tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		shape,
		"radius",
		radio_comienzo,
		radio_final,
		duracion,
		Tween.TRANS_LINEAR
	)
	tween.interpolate_property(
		self,
		"alpha",
		1.0,
		0,
		duracion,
		Tween.TRANS_LINEAR
	)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	terminar()


func _process(delta):
	update()


func _draw():
	draw_circle(
		Vector2.ZERO,
		shape.radius,
		Color(1, 1, 1, alpha)
	)


func enemigo_detectado(enemigo):
	enemigo.aplicar_stun(1.2)


func terminar():
	call_deferred("free")
