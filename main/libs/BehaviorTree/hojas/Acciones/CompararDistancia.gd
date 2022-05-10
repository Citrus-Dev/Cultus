# Toma dos posiciones del blackboard y comapra sus distancias.
# Da success o failure dependiendo del resultado y la condicion.
class_name CompararDistancia
extends Accion

enum opciones {
	MAYOR_QUE,
	MENOR_QUE
}
export(opciones) var verdadero_si
export(float) var valor_comparacion 
export(String) var bb_pos_1
export(String) var bb_pos_2
# Guarda la distancia en esta variable.
export(String) var resultado_distancia_entrada_bb

func tick(_agente, _blackboard : Blackboard):
	var pos1 = _blackboard.tomar_dato(bb_pos_1)
	var pos2 = _blackboard.tomar_dato(bb_pos_2)
	
	if pos1 == null or pos2 == null:
		return FAILURE
	
	var distancia = abs(pos1.distance_to(pos2))
	
	if resultado_distancia_entrada_bb != "":
		_blackboard.escribir_dato(resultado_distancia_entrada_bb, distancia)
	
	match verdadero_si:
		opciones.MAYOR_QUE:
			if valor_comparacion > distancia:
				return SUCCESS
			else:
				return FAILURE
		opciones.MENOR_QUE:
			if valor_comparacion < distancia:
				return SUCCESS
			else:
				return FAILURE
