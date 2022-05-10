# Hace disparar x cantidad de veces al enemigo
class_name AgregarDisparoRafaga
extends Accion

export(NodePath) onready var controlador_armas = get_node(controlador_armas) as ControladorArmasNPC
export(String) var nombre_obj_bb
export(int) var tiros = 1
export(bool) var sumar

func tick(_agente : Node, _blackboard : Blackboard):
	var obj = _blackboard.tomar_dato(nombre_obj_bb)
	if obj == null:
		return FAILURE
	
	controlador_armas.target_obj = obj
	
	_agente.disparando = true
	if sumar:
		controlador_armas.input_disparar += tiros
	else:
		controlador_armas.input_disparar = tiros
	
	return SUCCESS
