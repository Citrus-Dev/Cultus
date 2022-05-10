# Hace tick a su hijo repetidas veces.
class_name Repetidor
extends Decorador

export(int) var veces
export(String) var veces_bb

func tick(_agente, _blackboard : Blackboard):
	var contador = veces
	if veces_bb:
		contador = _blackboard.tomar_dato(veces_bb)
	
	var result
	for i in veces:
		result = hijo.tick(_agente, _blackboard)
	return result
 
