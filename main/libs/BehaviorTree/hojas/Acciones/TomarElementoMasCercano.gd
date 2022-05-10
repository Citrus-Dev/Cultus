# Toma una lista de objetos del blackboard y guarda el mas cercano a la posicion dada.
# Alternativamente puede hacer lo mismo pero tomar el más lejano.
class_name TomarElementoMasCercano
extends Accion

export(String) var lista_bb
export(String) var pos_comparar_bb
export(String) var resultado_guardar_bb
export(bool) var tomar_mas_lejano

func tick(_actor : Node, _blackboard : Blackboard):
	var lista = _blackboard.tomar_dato(lista_bb)
	var pos = _blackboard.tomar_dato(pos_comparar_bb)
	
	var result_dist : float = 1000
	var result : Vector2
	for i in lista:
		if !i is Vector2:
			i = i.global_position
		
		var dist = pos.distance_to(i)
		if tomar_mas_lejano:
			if dist > result_dist:
				result_dist = dist
				result = i
		else:
			if dist < result_dist:
				result_dist = dist
				result = i
	
	_blackboard.escribir_dato(resultado_guardar_bb, result)
	return SUCCESS
