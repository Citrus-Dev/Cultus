# Da success si el vector de un nodo es cero
class_name EsVectorCero
extends Accion

export(NodePath) var nodo_a_comparar_path
export(String) var nombre_vector_nodo
export(String) var nombre_vector_bb

var nodo_a_comparar : Node
var vector : Vector2

func tick(_agente : Node, _blackboard : Blackboard):
	if nodo_a_comparar_path:
		nodo_a_comparar = get_node(nodo_a_comparar_path)
		vector = nodo_a_comparar.get(nombre_vector_nodo)
	else:
		vector = _blackboard.tomar_dato(nombre_vector_bb)
	
	if vector == Vector2.ZERO:
		return SUCCESS
	print(vector)
	return FAILURE
