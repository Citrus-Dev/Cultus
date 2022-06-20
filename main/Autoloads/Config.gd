extends Node

const CAMINO_GUARDADO := "user://"
const ARCHIVO_GUARDADO := "config"
const SUFIJO_GUARDADO := ".cfg"

var config_data := {
	"volumen_sonido" : 0.8,
	"volumen_musica" : 0.5
}

func _init() -> void:
	pause_mode = PAUSE_MODE_PROCESS


func _ready() -> void:
	var err = existe_archivo_config()
	if err != OK:
		guardar_config()
		actualizar_opciones()
		return
	cargar_config()


func guardar_config():
	var data_string = var2str(config_data)
	
	if !existe_directorio(): return
	
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.WRITE)
	file.store_string(data_string)
	file.close()
	
	if err == OK:
		print(archivo_camino + "(config) guardado.")
	else:
		printerr("ERROR " + str(err) + " AL GUARDAR CONFIG")


func cargar_config():
	if !existe_directorio(): 
		return
	else:
		print("Config cargada con exito")
	
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.READ)
	
	var datos = str2var(file.get_as_text())
	config_data = datos
	file.close()
	
	actualizar_opciones()


func existe_directorio() -> bool:
	var dir = Directory.new()
	if dir.dir_exists(CAMINO_GUARDADO): 
		print("Directorio de guardado (config) encontrado...")
		return true
	else:
		print("Directorio de guardado (config) no encontrado. Creando...")
		var err = dir.make_dir_recursive(CAMINO_GUARDADO)
		if err != OK:
			printerr("Error " + str(err) + " al crear directorio de guardado (config).")
			return false
		return true


func existe_archivo_config():
	var file := File.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + SUFIJO_GUARDADO
	var err = file.open(archivo_camino, File.READ)
	return err


func actualizar_opciones():
	actualizar_opcion_vol_efectos()
	actualizar_opcion_vol_musica()


func actualizar_opcion_vol_efectos():
	var value_in_db = linear2db(config_data["volumen_sonido"])
	var sfx_index = AudioServer.get_bus_index("Musica")
	AudioServer.set_bus_volume_db(sfx_index, value_in_db)
	print(config_data["volumen_musica"])


func actualizar_opcion_vol_musica():
	var value_in_db = linear2db(config_data["volumen_musica"])
	var sfx_index = AudioServer.get_bus_index("Musica")
	AudioServer.set_bus_volume_db(sfx_index, value_in_db)
	print(config_data["volumen_musica"])






