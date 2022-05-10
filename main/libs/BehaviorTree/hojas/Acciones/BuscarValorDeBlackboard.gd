# Busca un valor en el blackboard, si lo encuentra devuelve success
class_name BuscarValorDeBlackboard
extends Condicion

export(String) var valor_a_buscar
export(bool) var debug

func tick(_agente : Node, _blackboard : Blackboard):
	if _blackboard.tomar_dato(valor_a_buscar) != null:
		if debug: breakpoint
		return SUCCESS
	return FAILURE
