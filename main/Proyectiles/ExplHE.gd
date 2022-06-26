class_name ExplHE
extends Node2D

export(NodePath) var path_collider 
export(float) var radio_comienzo = 32
export(float) var radio_final = 256
export(float) var duracion = 0.8

var collider : CollisionShape2D
var shape : CircleShape2D
var tween : Tween

var alpha := 1.0
var c := Color(0.92, 0.6, 0.14)

func _ready():
	$Area2D.connect("area_entered", self, "enemigo_detectado")
	
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
		Color(c.r, c.g, c.b, alpha)
	)


func enemigo_detectado(hitbox : Hitbox):
	var dmg_info = InfoDmg.new()
	dmg_info.dmg_cantidad = 60
	dmg_info.dmg_stun = 100
	hitbox.recibir_dmg(dmg_info)


func terminar():
	call_deferred("free")