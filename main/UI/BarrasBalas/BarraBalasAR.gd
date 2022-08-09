class_name BarraBalasAR
extends HudMedidorBalas

export(Texture) var bala_textura_gran
export(String) var id_balas_gran

export(NodePath) onready var container_g_path
export(NodePath) onready var text_rec_g_path
export(NodePath) onready var label_g_path 

var container_g : Node
var label_g : Node
var text_rec_g : TextureRect

# La variable modo no quiere andar asi que como este script igual no la iba a usar sacamos los if
# forro

func _ready():
	if container_g_path: container_g = get_node(container_g_path)
	if label_g_path: label_g = get_node(label_g_path)
	if text_rec_g_path: text_rec_g = get_node(text_rec_g_path)


func init_barra(_cantidad_max : int, _cantidad_actual : int):
	if bala_textura != null:
		for i in _cantidad_max:
			crear_sprite_bala()
	set_cantidad(_cantidad_actual)


func set_cantidad(_cantidad : int):
	set_cantidad_recarga(_cantidad)


func set_granadas(_cantidad : int):
	label_g.text = str(_cantidad)


func set_cantidad_recarga(_cantidad : int):
	for i in container.get_children().size():
		var alpha : float = 1.0 if i + 1 <= _cantidad else 0.2
		container.get_child(i).self_modulate = Color(1.0, 1.0, 1.0, alpha)


func set_balas_reserva(_cant : int):
	label.text = str(_cant)
	if _cant == 0:
		label.modulate = Color.red
	else:
		label.modulate = Color.white



















