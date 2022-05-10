# Imprime el texto dado.
class_name ImprimirTexto
extends Accion

export(String) var texto

func tick(_agente, _blackboard):
	print(texto)
	return SUCCESS
