class_name MedidorCooldown
extends Control

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress
export(NodePath) onready var icono = get_node(icono) as TextureRect

func actualizar_nombre(n : String):
	name = n


func set_icono_textura(text : Texture):
	icono.texture = text


func actualizar_valor(valor : float):
	progress_bar.value = valor


func set_color(col : Color):
	modulate = col
