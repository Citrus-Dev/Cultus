# Mueve al agente en la direccion dada.
class_name MoverseEnDireccion
extends Accion

export(String) var target_dir_bb
export(bool) var solo_x

func tick(_agente : Node, _blackboard : Blackboard):
	if _agente.get("input") == null:
		return FAILURE
	
	var dir : Vector2 = _blackboard.tomar_dato(target_dir_bb)
	if solo_x:
		_agente.input = Vector2(dir.x, 0).normalized()
	else:
		_agente.input = dir.normalized()
	
	return RUNNING
