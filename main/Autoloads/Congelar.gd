# Congela objetos por un tiempo limitado
extends Node

var objs : Dictionary

func _process(delta):
	for i in objs:
		objs[i]["t"] -= delta
		if objs[i]["t"] <= 0:
			# Termino de descontar el timer, descongelar el objeto y sacarlo de la lista
			alternar_proceso(i, true, true)
			objs.erase(i)


func congelar(_obj : Node, _t : float):
	if _obj.is_in_group("NO_CONGELAR") or !_obj.is_in_group("Personaje"): return
	objs[_obj] = {"t" : _t}
	alternar_proceso(_obj, false, true)
	print(_obj.name + " congelado por " + str(_t) + " segundos")


func alternar_proceso(_nodo : Node, _bool : bool, recursivo := false):
	if !is_instance_valid(_nodo): 
		return
	_nodo.set_process(_bool)
	_nodo.set_physics_process(_bool)
	_nodo.set_physics_process_internal(_bool)
	_nodo.set_process_input(_bool)
	
	if recursivo:
		for i in _nodo.get_children():
			alternar_proceso(i, _bool, recursivo)
