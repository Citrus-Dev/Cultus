# Crea un valor numérico en el blackboard y lo decrementa con el tiempo.
# También lo reinicia automáticamente al terminarse.
class_name CrearTimer
extends Accion

export(String) var nombre_timer_bb
export(String) var tiempo_a_esperar_bb
export(float) var tiempo_a_esperar

func tick(_agente : Node, _blackboard : Blackboard):
	var tiempo = _blackboard.tomar_dato(tiempo_a_esperar_bb)
	if tiempo == null:
		tiempo = tiempo_a_esperar
	
	# Hay un timer ya en el blackboard?
	var timer_potencial = _blackboard.tomar_dato(nombre_timer_bb)
	if timer_potencial == null or timer_potencial <= 0.0:
		# No hay o hay pero se termino, lo creamos
		_blackboard.escribir_dato(nombre_timer_bb, tiempo)
	else:
		# Ya hay, le descontamos tiempo y seguimos
		var delta : float = _blackboard.tomar_dato("delta")
		_blackboard.escribir_dato(nombre_timer_bb, timer_potencial - delta)
	return SUCCESS
