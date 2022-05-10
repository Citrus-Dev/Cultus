# Itera todos sus hijos en orden, deja de procesar cuando uno da SUCCESS
class_name Selector, "res://main/libs/BehaviorTree/icons/selector.svg"
extends Compuesto

func tick(_agente, _blackboard):
	for i in get_children():
		var resultado = i.tick(_agente, _blackboard)
		if resultado != FAILURE:
			return resultado
	
	return FAILURE
