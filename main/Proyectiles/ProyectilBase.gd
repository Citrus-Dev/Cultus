class_name ProyectilBase
extends KinematicBody2D

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
	velocity = Vector2.RIGHT.rotated(rotation).normalized() * move_speed
	
	init_estela()


func _physics_process(delta: float) -> void:
	var pos_frame_anterior = global_position
	
	global_position += velocity * delta
	
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
		global_position = res["position"]
		
		var collider = res["collider"]
		if collider is Hitbox:
			if !collider.monitorable: return
			var col = collider.owner.name
			collider.recibir_dmg(info_dmg)
		
		call_deferred("free")


func init_estela():
	estela = get_node("EstelaBase")
	if estela != null:
		estela.set_process(true)

