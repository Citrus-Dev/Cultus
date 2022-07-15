# Mensaje que aparece cuando agarras un pickup
class_name LabelPickup
extends Label

const VEL := 30.0

var lifetime : float

func _init(texto : String, tiempo := 1.5):
	text = texto
	lifetime = tiempo


func _process(delta):
	rect_global_position.y -= VEL * delta
	
	lifetime -= delta
	if lifetime <= 0:
		modulate.a -= delta
	if modulate.a <= 0:
		call_deferred("free")
