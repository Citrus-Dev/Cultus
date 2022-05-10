# Agrega un valor al blackboard
class_name EscribirEnBlackboard
extends Accion

# Solo se puede usar uno de estos
export(float) var valor_numero
export(String) var valor_string
export(Vector2) var valor_vector

export(String) var nombre_entrada_bb

func tick(_agente : Node, _blackboard : Blackboard):
	if _blackboard.datos.has(nombre_entrada_bb):
		return FAILURE
	
	if valor_numero:
		_blackboard.escribir_dato(nombre_entrada_bb, valor_numero)
	elif valor_string:
		_blackboard.escribir_dato(nombre_entrada_bb, valor_string)
	elif valor_vector:
		_blackboard.escribir_dato(nombre_entrada_bb, valor_vector)
	else:
		return FAILURE
	
	return SUCCESS
