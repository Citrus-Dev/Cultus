# Hace unb reakpoint. Solo para probar cosas
class_name DebugBreakpoint, "res://main/libs/BehaviorTree/icons/fail.svg"
extends Accion

func tick(_agente, _blackboard):
	breakpoint
	return SUCCESS
