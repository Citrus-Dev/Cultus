class_name TomarDireccionAObjeto
extends Accion

export(String) var obj_target_bb
export(String) var nombre_entrada_blackboard

func tick(_agente, _blackboard : Blackboard):
	if _blackboard.tomar_dato(obj_target_bb) == null:
		return FAILURE
	
	var obj = _blackboard.tomar_dato(obj_target_bb)
	var dir = _agente.global_position.direction_to(obj.global_position)
	
	_blackboard.escribir_dato(nombre_entrada_blackboard, dir.normalized())
	return SUCCESS
