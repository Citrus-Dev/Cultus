extends Node

var layer : CanvasLayer

func _ready():
	layer = CanvasLayer.new()
	layer.layer = 60
	layer.follow_viewport_enable = true
	add_child(layer)


func agregar_mensaje(pos : Vector2, texto : String, tiempo := 1.4, color := Color.white):
	var mensaje = LabelPickup.new(texto, tiempo)
	mensaje.align = Label.ALIGN_CENTER
	mensaje.valign = Label.VALIGN_CENTER
	mensaje.modulate = color
	layer.add_child(mensaje)
	mensaje.rect_global_position = pos - mensaje.rect_size / 2
