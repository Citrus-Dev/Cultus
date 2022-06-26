extends Node

const CAMINO_GUARDADO := "user://"
const ARCHIVO_GUARDADO := "config"
const SUFIJO_GUARDADO := ".ini"

var config_data := {
	"volumen_sonido" : 0.5,
	"volumen_musica" : 0.35
}

var keybinds := {
	"mov_izq" : KEY_A,
	"mov_der" : KEY_D,
	"mov_abaj" : KEY_S,
	"mov_arr" : KEY_W,
	"disparo_primario" : BUTTON_LEFT,
	"disparo_secundario" : BUTTON_RIGHT,
	"ciclar_var" : KEY_Z,
	"usar" : KEY_E,
	"arma_siguiente" : BUTTON_WHEEL_UP,
	"arma_anterior" : BUTTON_WHEEL_DOWN,
	"recargar" : KEY_R,
	"gancho" : KEY_Q,
	"escudo" : KEY_SHIFT,
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
	
	var file := ConfigFile.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + SUFIJO_GUARDADO
	
	for key in config_data.keys():
		file.set_value("CONFIG", key, config_data[key])
	
	for key in keybinds.keys():
		file.set_value("KEYBINDS", key, keybinds[key])
	
	file.save(archivo_camino)
	print(archivo_camino + "(config) guardado.")


func cargar_config():
	if !existe_directorio(): 
		return
	
	var file := ConfigFile.new()
	var archivo_camino = CAMINO_GUARDADO + ARCHIVO_GUARDADO + SUFIJO_GUARDADO
	var err = file.load(archivo_camino)
	
	for section in file.get_sections():
		match section:
			"CONFIG":
				for key in file.get_section_keys("CONFIG"):
					config_data[key] = file.get_value("CONFIG", key, null)
			"KEYBINDS":
				for key in file.get_section_keys("KEYBINDS"):
					keybinds[key] = file.get_value("KEYBINDS", key, null)
	
	print("Config cargada con exito")
	print(config_data)
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





