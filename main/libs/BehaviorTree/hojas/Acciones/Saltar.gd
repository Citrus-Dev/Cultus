# Hace saltar al agente acorde a los valores del borde
class_name Saltar
extends Accion

func tick(_agente : Node, _blackboard : Blackboard):
	if !_agente.is_on_floor() or _agente.muerto or _agente.stun:
		return FAILURE
	
	var borde : Borde = _blackboard.tomar_dato("borde")
	_blackboard.borrar_dato("borde")
	
	var jug : Jugador = get_tree().get_nodes_in_group("Jugador")[0]
	
	# Si el jugador esta por debaje de nosotros y el borde no indica que hay que saltar siempre
	# no saltar
	if !borde.siempre_saltar and jug.global_position.y > _agente.global_position.y:
		return FAILURE
	
	_agente.jump(_agente.jump_velocity * borde.mult_fuerza_salto)
	
	return SUCCESS
