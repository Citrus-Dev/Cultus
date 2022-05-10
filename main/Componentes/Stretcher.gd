# Cambia las diemnsiones de una sprite y las devuelve al tamaño normal despues de un tiempo.
class_name Stretcher
extends Node2D

var tween_return : Tween

func _ready() -> void:
	tween_return = Tween.new()
	add_child(tween_return)


func stretch(_dims := Vector2.ZERO, _duracion := 1.0):
#	if tween_return.is_active(): 
#		tween_return.stop_all()
#		scale = Vector2.ONE
	scale = _dims
	
	tween_return.interpolate_property(
		self,
		"scale",
		scale,
		Vector2.ONE,
		_duracion,
		Tween.TRANS_CUBIC
	)
	tween_return.start()
