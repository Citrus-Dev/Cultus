class_name Granada
extends KinematicBody2D

export(PackedScene) var spawn_en_impacto
export(float) var gravedad
export(float) var friccion
export(bool) var usar_timer
export(float) var timer

var vel_entrada : Vector2
var velocity : Vector2
var estela : EstelaBase

func _ready():
	velocity = vel_entrada
	
	var pos = global_position
	set_as_toplevel(true)
	position = pos
	
	init_estela()
	estela.set_process(false)
	estela.add_point(global_position)


func _physics_process(delta):
	estela.add_point(global_position)
	
	velocity.x = lerp(velocity.x, 0, friccion * delta)
	velocity.y += gravedad * delta
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	if !usar_timer:
		if col:
			impacto()
	else:
		if col:
			velocity = velocity.bounce(col.normal) * 0.8
			velocity.y *= 0.6
	
	if estela.points.size() > estela.numero_de_segmentos + 1:
		estela.remove_point(0)


func _process(delta):
	if !usar_timer: return
	timer -= delta
	if timer <= 0:
		impacto()


func init_estela():
	estela = get_node("EstelaBase")
	if estela != null:
		estela.set_process(true)


func impacto():
	if spawn_en_impacto:
		var inst = spawn_en_impacto.instance()
		var nivel = get_tree().get_nodes_in_group("Nivel")[0]
		inst.global_position = global_position
		nivel.add_child(inst)
	call_deferred("free")
