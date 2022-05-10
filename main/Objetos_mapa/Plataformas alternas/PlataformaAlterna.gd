# Clase padre para todas las plataformas que pueden alternar sus colisiones
class_name PlataformaAlterna
extends StaticBody2D

signal cambiado(_bool)

enum ESTADOS {
	INACTIVO,
	ACTIVO
}

export(ESTADOS) var estado_default = ESTADOS.ACTIVO
export(Color) var color_inactivo = Color("151515")

var activo : bool
var active_col_layer : int
var shaker := Shaker.new()

func _ready() -> void:
	shaker.target = get_child(0)
	shaker.decay = 1
	shaker.max_roll = 0
	shaker.max_offset = Vector2(2, 5)
	add_child(shaker)
	
	active_col_layer = collision_layer
	set_activo(estado_a_bool(estado_default))


func alternar(_toggle : bool):
	set_activo(_toggle)


func set_activo(_valor : bool):
	activo = _valor
	emit_signal("cambiado", activo)
	if activo:
		modulate = Color.white
		collision_layer = active_col_layer
	else:
		modulate = color_inactivo
		collision_layer = 0


func estado_a_bool(_estado : int) -> bool:
	return bool(_estado)
