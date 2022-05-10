class_name BorrarValorDeBlackboard
extends Accion

export(String) var valor_a_borrar

func tick(_agente : Node, _blackboard : Blackboard):
	if _blackboard.tomar_dato(valor_a_borrar) != null:
		_blackboard.borrar_dato(valor_a_borrar)
	return SUCCESS
