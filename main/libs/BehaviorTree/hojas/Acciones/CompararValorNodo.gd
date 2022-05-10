class_name CompararValorNodo
extends Condicion

enum OPCIONES {
	MAYOR_QUE,
	MENOR_QUE,
	MENOR_O_IGUAL_QUE,
	MAYOR_O_IGUAL_QUE,
	IGUAL_A
}

export(NodePath) var nodo_a_comparar_path 
export(String) var variable_nodo_a_comparar
export(String) var variable_bb_a_comparar
export(OPCIONES) var condicion
export(String) var valor_a_comparar

var nodo_a_comparar : Node
var variable_nodo

func _ready() -> void:
	if nodo_a_comparar_path:
		nodo_a_comparar = get_node(nodo_a_comparar_path)


func tick(_agente : Node, _blackboard : Blackboard):
	if is_instance_valid(nodo_a_comparar):
		variable_nodo = nodo_a_comparar.get(variable_nodo_a_comparar)
	else:
		variable_nodo = _blackboard.tomar_dato(variable_bb_a_comparar)
	if variable_nodo == null: return FAILURE
	
	variable_nodo = float(variable_nodo)
	
	match condicion:
		OPCIONES.MAYOR_QUE:
			if variable_nodo > float(valor_a_comparar):
				return SUCCESS
			else:
				return FAILURE
		OPCIONES.MENOR_QUE:
			if variable_nodo < float(valor_a_comparar):
				return SUCCESS
			else:
				return FAILURE
		OPCIONES.MENOR_O_IGUAL_QUE:
			if variable_nodo <= float(valor_a_comparar):
				return SUCCESS
			else:
				return FAILURE
		OPCIONES.MAYOR_O_IGUAL_QUE:
			if variable_nodo >= float(valor_a_comparar):
				return SUCCESS
			else:
				return FAILURE
		OPCIONES.IGUAL_A:
			if variable_nodo == valor_a_comparar:
				return SUCCESS
			else:
				return FAILURE
