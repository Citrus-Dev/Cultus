extends Node2D

export(float) var disp_vertical
export(float) var freq
var t : float

func _process(delta):
	t += delta
	global_position.y = anim_levitar(global_position.y, freq, disp_vertical)


func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x
