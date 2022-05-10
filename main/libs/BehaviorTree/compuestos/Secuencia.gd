# Itera todos sus hijos en orden hasta que uno falle, entonces para.
class_name Secuencia, "res://main/libs/BehaviorTree/icons/sequencer.svg"
extends Compuesto

func tick(_agente, _blackboard):
	for i in get_children():
		var resultado = i.tick(_agente, _blackboard)
		if resultado != SUCCESS:
			return resultado
	
	return SUCCESS
