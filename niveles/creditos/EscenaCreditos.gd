class_name EscenaCreditos
extends CanvasLayer

const SND_BOTON_TOCAR := preload("res://assets/sfx/ui_botton_tocar.wav")
const INFO := preload("res://main/InfoJuego.tres")
const ESCENA_LABEL_TITULO := preload("res://niveles/creditos/LabelCreditoTitulo.tscn")
const ESCENA_LABEL_NOMBRE := preload("res://niveles/creditos/LabelCreditoNombre.tscn")

export(NodePath) onready var boton_volver = get_node(boton_volver) as TextureButton

onready var cont_creditos: Container = get_node("MarginContainer/PanelContainer/VBoxContainer/ScrollContainer/cont_creditos")


func _ready():
	
	Musica.cambiar_musica(Musica.Tracks.MUS_MENU)
	boton_volver.connect("pressed", self, "tocar_boton")
	
	# Printear titulo y version
	var label = ESCENA_LABEL_TITULO.instance()
	label.text = "Cultus ver." + INFO.version_actual
	label.align = Label.ALIGN_CENTER
	cont_creditos.add_child(label)
	
	
	# Printear los creditos individuales
	for cred in INFO.creditos:
		var splitcreds = cred.rsplit("-", true)
		
		var l = ESCENA_LABEL_TITULO.instance()
		l.text = splitcreds[0]
		l.autowrap = true
		cont_creditos.add_child(l)
		
		var l_nom = ESCENA_LABEL_NOMBRE.instance()
		l_nom.text = splitcreds[1]
		l_nom.autowrap = true
		cont_creditos.add_child(l_nom)


func tocar_boton():
	Musica.hacer_sonido(SND_BOTON_TOCAR, Vector2.ZERO, 1.0, false)
	yield(get_tree().create_timer(0.05), "timeout")
	GameState.ir_al_menu()
