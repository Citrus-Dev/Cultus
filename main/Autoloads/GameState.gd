extends Node

enum Estados {
	MENU = 0,
	NORMAL = 1,
	COMBATE = 2,
	MUERTE = 3
}

var estado_actual : int

func _process(delta):
	DebugDraw.set_text("estado", Estados.keys()[estado_actual])
	procesar_estado(estado_actual)


func entrar_estado(est : int):
	match est:
		Estados.MENU:
			pass
		Estados.NORMAL:
			pass
		Estados.COMBATE:
			pass
		Estados.MUERTE:
			pass


func procesar_estado(est : int):
	match est:
		Estados.MENU:
			pass
		Estados.NORMAL:
			if buscar_enemigos_alertados() > 0:
				cambiar_estado(Estados.COMBATE)
		Estados.COMBATE:
			if buscar_enemigos_alertados() <= 0:
				cambiar_estado(Estados.NORMAL)
		Estados.MUERTE:
			pass


func cambiar_estado(est : int):
	estado_actual = est
	entrar_estado(est)


func buscar_enemigos_alertados() -> int:
	return get_tree().get_nodes_in_group("EnemigosAlertados").size()


func determinar_estado_inicial(nivel):
	if nivel is MainMenu:
		cambiar_estado(Estados.MENU)
		return
	cambiar_estado(Estados.NORMAL)





