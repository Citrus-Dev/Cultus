extends Node

const CAMINO_GUARDADO := "user://Saves/"
const ARCHIVO_GUARDADO := "Save_"
const SUFIJO_GUARDADO := ".save"

var slot_actual := "1"
var info_persist_global : Dictionary

func _init() -> void:
	pause_mode = PAUSE_MODE_PROCESS


func guardar_partida(_slot := ""):
	if _slot == "": _slot = slot_actual
	
	var datos := {}
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	
	datos["checkpoint_actual_escena"] = TransicionesDePantalla.checkpoint_actual_escena
	datos["inv_balas_estado"] = jug.controlador_armas.inv_balas.dict_balas
	datos["info_persist_global"] = info_persist_global
	
	var data_string = var2str(datos)
	
	existe_directorio()
	
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + _slot + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.WRITE)
	file.store_string(data_string)
	file.close()
	
	if err == OK:
		print(archivo_camino + " guardado.")
	else:
		printerr("ERROR " + str(err) + " AL GUARDAR PARTIDA")


func cargar_partida(_slot := ""):
	if _slot == "": _slot = slot_actual
	
	existe_directorio()
	
	if existe_partida(_slot) != OK:
		printerr("Partida guardada no encontrada (slot " + _slot + ")")
	
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + _slot + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.READ)
	
	var datos = str2var(file.get_as_text())
	file.close()
	
	TransicionesDePantalla.checkpoint_actual_escena = datos["checkpoint_actual_escena"]
	TransicionesDePantalla.inv_balas_estado = datos["inv_balas_estado"]
	info_persist_global = datos["info_persist_global"]
	
	TransicionesDePantalla.muerte = true
	get_tree().change_scene(TransicionesDePantalla.checkpoint_actual_escena)


func existe_directorio():
	var dir = Directory.new()
	if dir.dir_exists(CAMINO_GUARDADO): 
		print("Directorio de guardado encontrado...")
	else:
		print("Directorio de guardado no encontrado. Creando...")
		var err = dir.make_dir_recursive(CAMINO_GUARDADO)
		if err != OK:
			printerr("Error " + str(err) + " al crear directorio de guardado.")


func existe_partida(_slot : String):
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + _slot + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.READ)
	return err


func tomar_objetos_persistentes() -> Array:
	return get_tree().get_nodes_in_group("Persist")


func hay_datos_persist_del_nivel(nivel_filename : String) -> bool:
	return info_persist_global.has(nivel_filename)


func tomar_datos_persist_del_nivel(nivel_filename : String) -> Dictionary:
	return info_persist_global[nivel_filename]







