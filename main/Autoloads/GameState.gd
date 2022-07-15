extends Node

enum Estados {
	MENU = 0,
	NORMAL = 1,
	COMBATE = 2,
	MUERTE = 3
}

var estado_actual : int
var combate_terminado : bool

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS


func _process(delta):
#	DebugDraw.set_text("estado", Estados.keys()[estado_actual])
	procesar_estado(estado_actual, delta)


func entrar_estado(est : int):
	match est:
		Estados.MENU:
			pass
		Estados.NORMAL:
			Musica.set_track(Musica.Tracks.MUS_NORMAL)
		Estados.COMBATE:
			Musica.set_track(Musica.Tracks.MUS_COMBATE)
		Estados.MUERTE:
			pass


func procesar_estado(est : int, delta : float):
	match est:
		Estados.MENU:
			pass
		Estados.NORMAL:
			procesar_pausa(delta)
			if !combate_terminado and buscar_enemigos_alertados() > 0:
				cambiar_estado(Estados.COMBATE)
		Estados.COMBATE:
			procesar_pausa(delta)
			if buscar_enemigos() <= 0:
				combate_terminado = true
				cambiar_estado(Estados.NORMAL)
		Estados.MUERTE:
			procesar_pausa(delta)


func cambiar_estado(est : int):
	estado_actual = est
	entrar_estado(est)


func buscar_enemigos_alertados() -> int:
	return get_tree().get_nodes_in_group("EnemigosAlertados").size()


func buscar_enemigos() -> int:
	return get_tree().get_nodes_in_group("Enemigos").size()


func determinar_estado_inicial(nivel):
	combate_terminado = false
	if nivel is MainMenu:
		cambiar_estado(Estados.MENU)
		return
	cambiar_estado(Estados.NORMAL)


func procesar_pausa(delta : float):
	Pausa.procesar_pausa(delta)


# Funcion horrible nunca voy a volver a hacer esto
func hack_tomar_inv_balas() -> InvBalas:
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	return jug.controlador_armas.inv_balas

