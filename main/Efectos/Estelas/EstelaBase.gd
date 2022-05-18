# Crea un Line2D y coloca sus puntos atras del objeto padre
class_name EstelaBase
extends AntialiasedLine2D

export(int, 1, 16) var numero_de_segmentos 

var point
var parent : Node2D
var tween_fadeout : Tween

func _ready() -> void:
	# Por alguna razon esta variable se hace 0 si le pones 1 asi que hay que hacer esto
	if numero_de_segmentos == 0:
		numero_de_segmentos = 1
	
	set_as_toplevel(true)
	parent = get_parent()
	
	tween_fadeout = Tween.new()
	add_child(tween_fadeout)
	tween_fadeout.connect("tween_all_completed", self, "call_deferred", ["free"])
	
	set_process(false)


func _process(delta: float) -> void:
	point = parent.global_position
	add_point(point)
	if points.size() > numero_de_segmentos + 1:
		remove_point(0)





