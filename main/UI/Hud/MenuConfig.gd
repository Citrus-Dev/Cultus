class_name MenuConfig
extends Control

signal volver

export(NodePath) onready var slider_sfx = get_node(slider_sfx) as Slider
export(NodePath) onready var label_sfx = get_node(label_sfx) as Label
export(NodePath) onready var slider_musica = get_node(slider_musica) as Slider
export(NodePath) onready var label_musica = get_node(label_musica) as Label

func _ready():
	slider_sfx.connect("value_changed", self, "actualizar_slider_sfx")
	slider_musica.connect("value_changed", self, "actualizar_slider_musica")
	
	slider_sfx.value = Config.config_data["volumen_sonido"]
	slider_musica.value = Config.config_data["volumen_musica"]


func volver():
	emit_signal("volver")


func actualizar_slider_sfx(val : float):
	Config.actualizar_opcion_vol_efectos(val)
	label_sfx.text = str(val)


func actualizar_slider_musica(val : float):
	Config.actualizar_opcion_vol_musica(val)
	label_musica.text = str(val)
