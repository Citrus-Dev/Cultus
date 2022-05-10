# Guarda datos que van a compartir los nodos de un arbol de comportamientos
class_name Blackboard, "res://main/libs/BehaviorTree/icons/blackboard.svg"
extends Reference

var datos := {}

func escribir_dato(_llave : String, _valor):
	datos[_llave] = _valor


func borrar_dato(_llave : String):
	if datos.has(_llave):
		datos.erase(_llave)


func tomar_dato(_llave : String):
	if datos.has(_llave):
		return datos[_llave]
	else:
		return null


