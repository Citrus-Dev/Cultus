class_name SelectorMapas
extends Control

onready var container = get_node("Panel/ScrollContainer/VBoxContainer") as Container

func mostrar_mapas(_array_mapas : Array, _array_nombres : Array):
	for i in container.get_children():
		i.call_deferred("free")
	for i in _array_mapas.size():
		hacer_boton(_array_mapas[i], _array_nombres[i])


func hacer_boton(_dir : String, _nombre : String):
	var boton = Button.new()
	boton.text = _nombre
	
	boton.connect("pressed", self, "cargar_nivel", [_dir])
	
	container.add_child(boton)


func cargar_nivel(_dir : String):
	get_tree().change_scene(_dir)
	call_deferred("free")
