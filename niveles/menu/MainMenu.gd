extends Control

export(NodePath) onready var cont_botones = get_node(cont_botones) as Control
export(NodePath) onready var boton_continuar = get_node(boton_continuar) as Control
export(NodePath) onready var ng_prompt = get_node(ng_prompt) as Control

var GAME_INFO = preload("res://main/InfoJuego.tres")

func _ready():
	if Guardado.existe_partida("1") != OK:
		boton_continuar.visible = false


func empezar_nuevo_juego():
	var primer_nivel_path : String = GAME_INFO.primer_nivel
	get_tree().change_scene(GAME_INFO.primer_nivel)
	TransicionesDePantalla.checkpoint_actual_escena = GAME_INFO.primer_nivel
	TransicionesDePantalla.inv_balas_estado = GAME_INFO.INV_BALAS_DEFAULT


func mostrar_prompt_nuevo_juego(toggle : bool):
	ng_prompt.visible = toggle
	esconder_menu(!toggle)


func continuar():
	Guardado.cargar_partida("1")


func mostrar_opciones(toggle : bool):
	pass


func quit():
	get_tree().quit()


func esconder_menu(toggle : bool):
	for i in cont_botones.get_children():
		i.visible = toggle

