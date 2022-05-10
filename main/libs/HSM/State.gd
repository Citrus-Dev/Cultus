class_name State
extends Node

"""
State interface to use in hierarchical state machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to it's parent.
It's up to the user to call the parent's state functions, e.g. 'get_parent().physics_process(delta)'.
Use state as a child of a StateMachine node.
"""

onready var _state_machine : StateMachine = _get_state_machine(self)


func enter(msg : Dictionary = {}) -> void:
	return 


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 


# Iterates through all the parents until it finds a state machine node.
func _get_state_machine(node : Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		var return_this = _get_state_machine(node.get_parent())
		return return_this
	return node


# Devuelve una referencia al jugador, de haber una
func buscar_jugador() -> Jugador:
	var juglist = get_tree().get_nodes_in_group("Jugador")
	if juglist.size() < 1:
		return null
	return juglist[0]
