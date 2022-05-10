class_name MoverHaciaPos
extends Accion

export(String) var target_pos_bb
export(String) var target_ref_bb
export(float) var distancia_minima
export(bool) var solo_x

func tick(_agente : Node, _blackboard : Blackboard):
	if _agente.get("input") == null:
		return FAILURE
	
	var target_pos : Vector2
	if target_ref_bb:
		target_pos = _blackboard.tomar_dato(target_ref_bb).position
	elif target_pos_bb:
		target_pos = _blackboard.tomar_dato(target_pos_bb)
	
	if !solo_x:
		_agente.input = (_agente.global_position.direction_to(target_pos)).normalized()
	else:
		_agente.input.x = sign(_agente.global_position.direction_to(target_pos).x)
	
	if _agente.global_position.distance_to(target_pos) < distancia_minima:
		return SUCCESS
	return RUNNING

