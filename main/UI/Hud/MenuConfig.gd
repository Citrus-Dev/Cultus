class_name MenuConfig
extends Control

const TEX_ICONO_FX_0 := preload("res://assets/ui/sonido_fx_0.tres")
const TEX_ICONO_FX_1 := preload("res://assets/ui/sonido_fx_1.tres")
const CFG_FULLSCREEN := "display/window/size/fullscreen"
const CFG_CONSOLA := "global/consola"

signal volver

export(NodePath) onready var slider_sfx = get_node(slider_sfx) as Slider
export(NodePath) onready var label_sfx = get_node(label_sfx) as Label
export(NodePath) onready var icono_sfx = get_node(icono_sfx) as TextureRect
export(NodePath) onready var slider_musica = get_node(slider_musica) as Slider
export(NodePath) onready var label_musica = get_node(label_musica) as Label
export(NodePath) onready var checkbox_pantalla_completa = get_node(checkbox_pantalla_completa) as CheckBox
export(NodePath) onready var checkbox_consola = get_node(checkbox_consola) as CheckBox

func _ready():
	slider_sfx.connect("value_changed", self, "actualizar_slider_sfx")
	slider_musica.connect("value_changed", self, "actualizar_slider_musica")
	
	slider_sfx.value = Config.config_data["volumen_sonido"]
	slider_musica.value = Config.config_data["volumen_musica"]
	
#	checkbox_pantalla_completa.pressed = ProjectSettings.get_setting(CFG_FULLSCREEN)
	checkbox_pantalla_completa.pressed = OS.window_fullscreen
	checkbox_pantalla_completa.connect("toggled", self, "set_pantalla_completa")
	
	checkbox_consola.pressed = ProjectSettings.get_setting(CFG_CONSOLA)
	checkbox_consola.connect("toggled", self, "set_consola")


func volver():
	emit_signal("volver")


func actualizar_slider_sfx(val : float):
	Config.actualizar_opcion_vol_efectos(val)
	icono_sfx.texture = TEX_ICONO_FX_1 if val > 0 else TEX_ICONO_FX_0
	label_sfx.text = str(val)


func actualizar_slider_musica(val : float):
	Config.actualizar_opcion_vol_musica(val)
	label_musica.text = str(val)


func set_pantalla_completa(toggle: bool):
	Config.set_pantalla_completa(toggle)

func set_consola(toggle: bool):
	ProjectSettings.set_setting(CFG_CONSOLA, toggle)
