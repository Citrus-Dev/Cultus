class_name HudDisplayArma
extends Control

const MARCO_TEXTURA_SELEC: Texture = preload("res://assets/ui/marco_hudarma_select.tres")
const MARCO_TEXTURA_DESELEC: Texture = preload("res://assets/ui/marco_hudarma_deselect.tres")

export(NodePath) onready var textura_marco = get_node(textura_marco) as TextureRect
export(NodePath) onready var textura_arma = get_node(textura_arma) as TextureRect

var slot: int

func set_select(toggle: bool):
	textura_marco.texture = MARCO_TEXTURA_SELEC if toggle else MARCO_TEXTURA_DESELEC
