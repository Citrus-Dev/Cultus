# Invierte un resultado (NOT)
class_name Inversor, "res://main/libs/BehaviorTree/icons/inverter.svg"
extends Decorador

export(bool) var debug_bp_on_failure
export(bool) var debug_bp_on_success
export(bool) var debug_bp_on_running

func tick(_agente, _blackboard):
	var result = hijo.tick(_agente, _blackboard)
	if result == SUCCESS:
		if debug_bp_on_failure: breakpoint
		return FAILURE
	if result == FAILURE:
		if debug_bp_on_success: breakpoint
		return SUCCESS
	if debug_bp_on_running: breakpoint
	return RUNNING
