# Guarda una propiedad del agente en el blackboard
class_name GuardarPropiedadBlackboard
extends Accion

export(String) var nombre_propiedad
export(String) var nombre_entrada_blackboard

func tick(_agente, _blackboard : Blackboard):
	var prop = _agente.get(nombre_propiedad)
	if prop == null:
		return FAILURE
	else:
		_blackboard.escribir_dato(nombre_entrada_blackboard, prop)
		return SUCCESS
