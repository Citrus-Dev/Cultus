class_name LlamarFuncionNodo
extends Accion

export(NodePath) onready var nodo = get_node(nodo) as Node
export(String) var funcion
export(bool) var deferred

func tick(_agente : Node, _blackboard : Blackboard):
	if !nodo.has_method(funcion): 
		return FAILURE
	if deferred:
		nodo.call_deferred(funcion)
	else:
		nodo.call(funcion)
	return SUCCESS
