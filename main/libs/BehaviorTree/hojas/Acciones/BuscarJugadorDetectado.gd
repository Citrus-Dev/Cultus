# Devuelve success si el agente tiene una referencia al jugador en "objetivo"
class_name BuscarJugadorDetectado
extends Condicion

func tick(_agente : Node, _blackboard : Blackboard):
	if _agente.objetivo is Jugador:
		return SUCCESS
	return FAILURE
