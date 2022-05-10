class_name GuardarPosMouse
extends Accion

export(String) var nombre_entrada_blackboard

func tick(_agente, _blackboard : Blackboard):
	var mousepos = get_viewport().get_mouse_position()
	_blackboard.escribir_dato(nombre_entrada_blackboard, mousepos)
	return SUCCESS
