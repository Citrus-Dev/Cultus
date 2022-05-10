# Toma todos los nodos de un grupo y los pone en una lista 
# opcionalmente guardandolos en blackboard.
class_name TomarNodosDeGrupo
extends Accion

export(String) var nombre_grupo
export(String) var nombre_entrada_blackboard
export(bool) var obj_unico

func tick(_agente, _blackboard : Blackboard):
	if get_tree().get_nodes_in_group(nombre_grupo).size() == 0:
		return FAILURE
	
	var grupo = get_tree().get_nodes_in_group(nombre_grupo)
	
	if nombre_entrada_blackboard:
		if obj_unico:
			_blackboard.escribir_dato(nombre_entrada_blackboard, grupo[0])
		else:
			_blackboard.escribir_dato(nombre_entrada_blackboard, grupo)
	
	return SUCCESS
