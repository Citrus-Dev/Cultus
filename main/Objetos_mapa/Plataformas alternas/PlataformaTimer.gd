# Alterna su colisiónn en un timer consistente
class_name PlataformaTimer
extends PlataformaAlterna

export(float) var tiempo_de_intervalo

var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = tiempo_de_intervalo
	timer.connect("timeout", self, "timer_toggle")
	add_child(timer)


func timer_toggle():
	alternar(!activo)
	timer.start( )
