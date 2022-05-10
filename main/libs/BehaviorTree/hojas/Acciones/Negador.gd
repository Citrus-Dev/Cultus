# Devuelve siempre failure
class_name Negador, "res://main/libs/BehaviorTree/icons/fail.svg"
extends Accion

func tick(_agente, _blackboard):
	return FAILURE
