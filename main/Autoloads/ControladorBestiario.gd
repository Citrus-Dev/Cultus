extends Node

const CAMINO_GUARDADO := "user://Saves/"
const ARCHIVO_GUARDADO := "Bestiario.dat"

signal bestiario_abierto

var datos_bestiario: Array

func _ready() -> void:
	print("existe_datos_bestiario: " + str(existe_datos_bestiario()))




func existe_datos_bestiario() -> bool:
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO 
	var err = file.open(archivo_camino, File.READ)
	return err == OK



func guardar_datos_bestiario():
	var data_string: String = var2str(datos_bestiario)
	
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO 
	var err = file.open(archivo_camino, File.WRITE)
	if err != OK:
		printerr("Error al guardar datos del bestiario")
		return
	
	file.store_string(data_string)
	file.close()
	
	print("Archivo de bestiario guardado.")



func cargar_datos_bestiario():
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO 
	var err = file.open(archivo_camino, File.READ)
	if err != OK:
		printerr("Error al cargar datos del bestiario")
		return
	
	datos_bestiario = str2var(file.get_as_text())
	file.close()
	
	print("Archivo de bestiario cargado.")

