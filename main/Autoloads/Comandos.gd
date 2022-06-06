extends Node

# Todos los comandos tienen que seguir estas pautas para funcionar en la consola:
# -empezar con el prefijo "c_"
# -Llevar un unico argumento que sea un string (si la funcion no toma argumentos ponerle un valor default)
# -Devolver un string (el mensaje que se va a mostrar en la consola)

const DIR_NIVELES = "res://niveles/"

var noclip : bool
var debug_steer : bool

# Muestra una lista de todos los comandos.
func c_comandos(_int := "1") -> String:
	var list := []
	for a in ConsoleAutoload.command_list:
		list.append(a)
	return "Comandos encontrados: " + str(list)


# Activa y desactiva el noclip.
func c_noclip(_nada : String = "sexo") -> String:
	if _nada != "sexo":
		var strint = int(_nada)
		noclip = false if strint == 0 else true
	else:
		noclip = !noclip
	return "Volar activado." if noclip else "Volar desactivado."


# Reinicia la escena.
func c_restart(_nada : String = "jiju") -> String:
	get_tree().call_deferred("reload_current_scene")
	return "Reiniciando."


func c_creditos(_string : String = "jhjg") -> String:
	var info = load("res://main/InfoJuego.tres")
	var string_creditos : String
	
	for i in info.creditos.size():
		var cred = info.creditos[i]
		string_creditos += cred
		if i != info.creditos.size() - 1:
			string_creditos += "\n"
	
	return string_creditos


# Carga un mapa por nombre
func c_map(_nombre : String = "=") -> String:
	var arr = BuscarMapa.buscar_lista_de_mapas(DIR_NIVELES)
	var nombre_archivo = _nombre.to_lower() + ".tscn"
	for i in arr:
		if i.to_lower().ends_with(nombre_archivo):
			get_tree().change_scene(i)
			return "Encontrado: " + str(i)
			break
	
	return "Mapa no encontrado."


func c_maplist(_name : String = "") -> String:
	var selector = (load("res://main/UI/SelectorMapas/SelectorMapas.tscn")).instance()
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	var consola = get_tree().get_nodes_in_group("ConsoleGUI")[0]
	
	consola.toggle_visible()
	hud.add_child(selector)
	
	var arr = BuscarMapa.buscar_lista_de_mapas(DIR_NIVELES)
	var mapas_nombres := []

	for mapa in arr:
		var string_list = mapa.split("/") as Array
		var new_string : String = string_list.back().trim_suffix(".tscn")
		mapas_nombres.append(new_string.to_lower())
	
	selector.mostrar_mapas(arr, mapas_nombres)
	
	return ""


# Devuelve una lista de mapas para cargar con el comando map.
#func c_maplist(_nada : String = "") -> String:
#	var arr = BuscarMapa.buscar_lista_de_mapas(DIR_NIVELES)
#	var mapas_nombres := []
#
#	for mapa in arr:
#		var string_list = mapa.split("/") as Array
#		var new_string : String = string_list.back().trim_suffix(".tscn")
#		mapas_nombres.append(new_string.to_lower())
#
#	return str(mapas_nombres)


# Muestra las colisiones.
func c_debug_col(_toggle : String = "-1") -> String:
	var boolean : bool
	if not int(_toggle) in [0, 1]:
		boolean = !get_tree().debug_collisions_hint
	else:
		boolean = bool(int(_toggle))
	
	get_tree().set_debug_collisions_hint(boolean)
	var mes = "activada." if boolean else "desactivada."
	var extra := "\n IMPORTANTE: El cambio se aplica despues de reiniciar el nivel."
	return "Visualización de colisiones " + mes + extra


# Cambia si se pueden ver los datos debug del steering
func c_debug_steer(_how : String = "mmm") -> String:
	if _how != "mmm":
		var strint = int(_how)
		debug_steer = false if strint == 0 else true
	else:
		debug_steer = !debug_steer
	
	if debug_steer:
		return "Datos debug de steering activados." 
	else: 
		return "Datos debug de steering desactivados."


# Hace daño al jugador
func c_hurt(_dolor : String = "") -> String:
	if _dolor == "":
		return "Argumentos incorrectos (hurt [cantidad de daño])"
	var strint = int(_dolor)
	
	var jug = get_tree().get_nodes_in_group("Jugador")[0] as Jugador
	var status = jug.status as Status
	
	var dmg = InfoDmg.new()
	dmg.dmg_cantidad = strint
	
	status.aplicar_dmg(dmg)
	return "Aplicado " + str(strint) + " de daño al jugador."


# Mata al jugador
func c_kill(_ouch : String = "") -> String:
	var jug = get_tree().get_nodes_in_group("Jugador")[0] as Jugador
	var status = jug.status as Status
	var dmg = InfoDmg.new()
	dmg.dmg_cantidad = 9999999
	
	status.aplicar_dmg(dmg)
	
	var respuestas := [
		"Apaga",
		"Ok",
		"Sentate",
		"Chau",
		"Malardo"
	]
	
	randomize()
	var rand_index : int = randi() % respuestas.size()
	return respuestas[rand_index] + "."


func c_mirar(_nada := "a") -> String:
	var jug : Jugador = get_tree().get_nodes_in_group("Jugador")[0]
	if _nada != "a":
		var strint = int(_nada)
		jug.alternar_checkpoint(false if strint == 0 else true)
	else:
		jug.alternar_checkpoint(!jug.usando_checkpoint)
	return "Mirar activado." if jug.usando_checkpoint else "Mirar desactivado."


func c_guardar(_slot := "0") -> String:
	Guardado.guardar_partida(_slot)
	return "Partida guardada en slot " + _slot


func c_save(_slot := "0") -> String:
	return c_guardar(_slot)


func c_cargar(_slot := "0") -> String:
	Guardado.cargar_partida(_slot)
	return "Partida cargada de slot " + _slot


func c_load(_slot := "0") -> String:
	return c_cargar(_slot)


# TODO optimizar estas tres funciones que tienen codigo repetido
func c_give(_arma := "") -> String:
	var armas := Armas.new()
	if _arma in armas.armas_lista:
		return give_arma(_arma)
	elif _arma in armas.skills_lista:
		return give_skill(_arma)
	else:
		return "Arma o habilidad no encontrada"


func give_arma(_arma := "") -> String:
	if get_tree().get_nodes_in_group("ArmasJugador").size() <= 0:
		return "ERROR INESPERADO"
	var cont : ControladorArmasJugador = get_tree().get_nodes_in_group("ArmasJugador")[0]
	var armas := Armas.new()
	
	if _arma in armas.armas_lista:
		cont.agregar_arma_string(_arma)
		return "Giveado: " + _arma
	else:
		return "Arma o habilidad no encontrada"


func give_skill(_skill := "") -> String:
	if get_tree().get_nodes_in_group("Jugador").size() <= 0:
		return "ERROR INESPERADO"
	var jug : Jugador = get_tree().get_nodes_in_group("Jugador")[0]
	var armas := Armas.new()
	
	if _skill in armas.skills_lista:
		var skill = load(armas.skills_lista[_skill])
		var skill_inst = skill.instance()
		jug.agregar_skill(_skill)
		return "Giveado: " + _skill
	else:
		return "Arma o habilidad no encontrada"


func c_impulse(_nada := "") -> String:
	var armas := Armas.new()
	for arma in armas.armas_jugador:
		give_arma(arma)
	for skill in armas.skills_lista:
		give_skill(skill)
	return "Dadas todas las armas y habilidades."


func c_graciosa(__ := "0") -> String:
	for i in int(__):
		c_kill()
	return "ok"
