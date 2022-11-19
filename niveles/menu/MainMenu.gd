class_name MainMenu
extends Control

const SND_BOTON_TOCAR := preload("res://assets/sfx/ui_botton_tocar.wav")

export(NodePath) onready var cont_botones = get_node(cont_botones) as Control
export(NodePath) onready var boton_continuar = get_node(boton_continuar) as Control
export(NodePath) onready var boton_creditos = get_node(boton_creditos) as Control
export(NodePath) onready var ng_prompt = get_node(ng_prompt) as Control
export(NodePath) onready var menu_config = get_node(menu_config) as MenuConfig

var GAME_INFO = preload("res://main/InfoJuego.tres")

func _ready():
	GameState.determinar_estado_inicial(self)
	if Guardado.existe_partida("1") != OK:
		boton_continuar.visible = false
	boton_creditos.connect("pressed", GameState, "ver_credtios")
	Musica.cambiar_musica(Musica.Tracks.MUS_MENU)


func sonido_tocar_boton():
	Musica.hacer_sonido(SND_BOTON_TOCAR, Vector2.ZERO, 1.0, false)


func empezar_nuevo_juego():
	sonido_tocar_boton()
	var primer_nivel_path : String = GAME_INFO.primer_nivel
	get_tree().change_scene(GAME_INFO.primer_nivel)
	TransicionesDePantalla.checkpoint_actual_escena = GAME_INFO.primer_nivel
	TransicionesDePantalla.trigger_objetivo = ""
	TransicionesDePantalla.inv_balas_estado = GAME_INFO.INV_BALAS_DEFAULT
	TransicionesDePantalla.inv_armas = {}
	TransicionesDePantalla.inv_variantes = {}
	TransicionesDePantalla.inv_skills = {}


func mostrar_prompt_nuevo_juego(toggle : bool):
	sonido_tocar_boton()
	ng_prompt.visible = toggle
	esconder_menu(!toggle)


func continuar():
	sonido_tocar_boton()
	Guardado.cargar_partida("1")


func mostrar_opciones(toggle : bool):
	sonido_tocar_boton()
	esconder_menu(!toggle)
	menu_config.visible = toggle


func mostrar_config():
	sonido_tocar_boton()
	mostrar_opciones(true)


func quit():
	sonido_tocar_boton()
	yield(get_tree().create_timer(0.05), "timeout")
	get_tree().quit()


func esconder_menu(toggle : bool):
	for i in cont_botones.get_children():
		i.visible = toggle




func play():
	pass # Replace with function body.
