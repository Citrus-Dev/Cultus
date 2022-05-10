# Busca objetos en un radio, y opcionalmente revisa que no haya obstrucciones (paredes etc)
class_name LOSCheck
extends Area2D

signal nuevo_objeto_en_los(_obj)
signal obj_entrado(_obj)
signal obj_salido(_obj)

export(float) var radio = 96.0
export(int) var mascara_colision
export(Color) var debug_color_prueba = Color("4e0fc771")
export(bool) var debug
export(bool) var check_areas

onready var col := CollisionShape2D.new()

var obj_en_vision : Array

func _ready():
	init()


func _physics_process(delta):
	procesar_los()
	if debug: 
		debug_process()


func init():
	modulate = debug_color_prueba
	collision_layer = 0
	collision_mask = mascara_colision
	col.shape = CircleShape2D.new()
	col.shape.radius = radio
	add_child(col)
	
	connect("body_entered", self, "emitir_senales", ["obj_entrado"])
	connect("body_exited", self, "emitir_senales", ["obj_salido"])


# seÑales*
func emitir_senales(_body : KinematicBody2D, _signal : String):
	emit_signal(_signal, _body)


func debug_process():
	for i in obj_en_vision:
		DebugDraw.set_text(i.name, i)


func procesar_los():
	var arr := []
	var lista := []
	if check_areas:
		lista = get_overlapping_areas()
	else:
		lista = get_overlapping_bodies()
	
	for i in lista:
		if hay_los(i):
			arr.append(i)
			if !i in obj_en_vision:
				emit_signal("nuevo_objeto_en_los", i)
	obj_en_vision = arr


# Revisa si hay linea de vision libre hacia el objeto
func hay_los(_body : KinematicBody2D) -> bool:
	if _body == null: return false
	var space = get_world_2d().direct_space_state
	var rc = space.intersect_ray(
		global_position,
		_body.global_position,
		[self, _body],
		1
	)
	
	return !rc.has("collider")
