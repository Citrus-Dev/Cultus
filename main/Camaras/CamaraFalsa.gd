class_name CamaraFalsa
extends Camera2D

signal cambio_de_limites(_instant)

var current_active_bounds : CameraBounds

func tween_limits(_limits : Array, _instant : bool = false):
	limit_top = _limits[0]
	limit_bottom = _limits[1]
	limit_left = _limits[2]
	limit_right = _limits[3]
	emit_signal("cambio_de_limites", _instant)
