class_name HudMedidorBalas
extends Control

export(NodePath) onready var container_path
export(NodePath) onready var text_rec_path
export(NodePath) onready var label_path 
export(String, "RECARGA", "NO_RECARGA") var modo
export(Texture) var bala_textura
export(String) var id_balas

var container : Node
var label : Node
var text_rec : TextureRect

func _ready():
	if container_path: container = get_node(container_path)
	if label_path: label = get_node(label_path)
	if text_rec_path: text_rec = get_node(text_rec_path)


func init_barra(_cantidad_max : int, _cantidad_actual : int):
	if bala_textura != null and modo == "RECARGA":
		for i in _cantidad_max:
			crear_sprite_bala()
	if modo == "NO_RECARGA":
		text_rec.texture = bala_textura
	set_cantidad(_cantidad_actual)


func crear_sprite_bala():
	var texture = TextureRect.new()
	texture.texture = bala_textura
	container.add_child(texture)


func set_cantidad(_cantidad : int):
	match modo:
		"RECARGA":
			set_cantidad_recarga(_cantidad)
		"NO_RECARGA":
			set_cantidad_no_recarga(_cantidad)


func set_cantidad_recarga(_cantidad : int):
	for i in container.get_children().size():
		var alpha : float = 1.0 if i + 1 <= _cantidad else 0.2
		container.get_child(i).self_modulate = Color(1.0, 1.0, 1.0, alpha)


func set_cantidad_no_recarga(_cantidad : int):
	set_balas_reserva(_cantidad)


func set_balas_reserva(_cant : int):
	label.text = str(_cant)


func _exit_tree():
	ControladorUi.medidor_balas = null
