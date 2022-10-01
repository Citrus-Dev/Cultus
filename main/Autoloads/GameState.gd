extends Node

const INFO := preload("res://main/InfoJuego.tres")
const CHANCE_EVENTO := 60000

signal jugador_muerto

enum Estados {
	MENU = 0,
	NORMAL = 1,
	COMBATE = 2,
	MUERTE = 3
}

var estado_actual : int
var combate_terminado : bool
var vio_tutorial_variantes: bool

var cursor: Cursor


func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS


func _ready():
	# Crear una capa nueva para el cursor
	var capa = CanvasLayer.new()
	capa.layer = 512
	add_child(capa)
	
	# Crear cursor
	cursor = Cursor.new()
	capa.add_child(cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func _process(delta):
#	DebugDraw.set_text("estado", Estados.keys()[estado_actual])
	procesar_estado(estado_actual, delta)
	
	var rng = randi() % CHANCE_EVENTO
	if rng == CHANCE_EVENTO:
		evento()


func cambiar_estado(est : int):
	estado_actual = est
	entrar_estado(est)


func entrar_estado(est : int):
	match est:
		Estados.MENU:
			Musica.set_track(Musica.Tracks.MUS_MENU)
			cursor.set_cursor_estilo(0)
		Estados.NORMAL:
			Musica.set_track(Musica.Tracks.MUS_NORMAL)
			cursor.set_cursor_estilo(1)
		Estados.COMBATE:
			Musica.set_track(Musica.Tracks.MUS_COMBATE)
			cursor.set_cursor_estilo(1)
		Estados.MUERTE:
			cursor.set_cursor_estilo(1)
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


func buscar_enemigos_alertados() -> int:
	return get_tree().get_nodes_in_group("EnemigosAlertados").size()


func buscar_enemigos() -> int:
	return get_tree().get_nodes_in_group("Enemigos").size()


func determinar_estado_inicial(nivel):
	combate_terminado = false
	# if nivel is MainMenu
	# El editor se caga encima si ponemos esto asi que ponemos
	if nivel.get("GAME_INFO") != null:
		cambiar_estado(Estados.MENU)
		return
	cambiar_estado(Estados.NORMAL)


func procesar_pausa(delta : float):
	Pausa.procesar_pausa(delta)


# Funcion horrible nunca voy a volver a hacer esto
func hack_tomar_inv_balas() -> Object:
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	return jug.controlador_armas.inv_balas


# Mati forro
func evento():
	if get_tree().get_nodes_in_group("Jugador").size() < 1: return
	var jug : Node2D = get_tree().get_nodes_in_group("Jugador")[0]
	jug.pause_mode = PAUSE_MODE_PROCESS
#	ControladorUi.mensaje_ui("Hola", 2.0, true)
	get_tree().paused = true
	jug.alternar_checkpoint(true)
	
	var timer = Timer.new()
	jug.add_child(timer)
	timer.start(2.0)
	
	yield(timer, "timeout")
	
	timer.call_deferred("free")
	get_tree().paused = false
	jug.alternar_checkpoint(false)


func ir_al_menu():
	get_tree().change_scene("res://niveles/menu/MainMenu.tscn")


func ver_credtios():
	get_tree().change_scene(INFO.escena_creditos)

