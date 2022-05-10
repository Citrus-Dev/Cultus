# Invierte un vector, haciendolo apuntar a la direccion contraria
class_name InvertirVector
extends Accion

const COOLDOWN_TIEMPO := 0.8

export(String) var nombre_vector_bb
export(bool) var solo_x
export(bool) var solo_y

var cooldown := Timer.new()

func _ready() -> void:
	add_child(cooldown)
	cooldown.wait_time = COOLDOWN_TIEMPO
	cooldown.one_shot = true


func tick(_agente : Node, _blackboard : Blackboard):
	if !cooldown.is_stopped():
		return FAILURE
	
	var dato = _blackboard.tomar_dato(nombre_vector_bb)
	if dato == null or !dato is Vector2:
		return FAILURE
	
	var vect : Vector2 = dato as Vector2
	vect *= -1
	
	var vec_final : Vector2
	if solo_x: vec_final = Vector2(vect.x, 0)
	if solo_y: vec_final = Vector2(0, vect.y)
	
	cooldown.start()
	_blackboard.escribir_dato(nombre_vector_bb, vec_final)
	return SUCCESS
