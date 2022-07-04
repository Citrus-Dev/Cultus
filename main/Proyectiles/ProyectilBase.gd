class_name ProyectilBase
extends KinematicBody2D

export(PackedScene) var efecto
export(float) var move_speed
export(float) var lifetime

var bounding_box : Rect2
var velocity : Vector2

var life_timer = Timer.new()
var info_dmg : InfoDmg
var estela : EstelaBase

# Variable para la fuerza de las olas que hace al entrar al agua
var fuerza_de_entrada : float = 1.0 

func _ready() -> void:
	life_timer.wait_time = lifetime
	life_timer.autostart = true
	life_timer.one_shot = true
	life_timer.connect("timeout", self, "call_deferred", ["free"])
	add_child(life_timer)
	
	var pos = global_position
	set_as_toplevel(true)
	position = pos
	set_velocity()
	
	init_estela()
	estela.set_process(false)
	estela.add_point(global_position)


func _physics_process(delta: float) -> void:
	var pos_frame_anterior = global_position
	
	global_position += velocity * delta
	estela.add_point(global_position)
	
	var space_state = get_world_2d().direct_space_state
	var res = space_state.intersect_ray(
		pos_frame_anterior,
		global_position,
		[self],
		collision_mask,
		true,
		true
	)
	
	if !res.empty():
		if efecto:
			instanciar_efecto(res["position"], res["normal"].angle())
		var collider = res["collider"]
		if collider is Hitbox:
			if !collider.monitorable: return
			var col = collider.owner.name
			collider.recibir_dmg(info_dmg)
		global_position = res["position"]
		call_deferred("free")
	
	if estela.points.size() > estela.numero_de_segmentos + 1:
		estela.remove_point(0)


func set_velocity():
	velocity = Vector2.RIGHT.rotated(rotation).normalized() * move_speed


func init_estela():
	estela = get_node("EstelaBase")
	if estela != null:
		estela.set_process(true)


# Cambia la mascara de colision para que pegue a enemigos (reflejado del escudo)
func reflejar():
	collision_mask = 33


func instanciar_efecto(pos : Vector2, rot : float):
	var new = efecto.instance()
	get_parent().add_child(new)
	new.rotation = rot
	new.global_position = pos
