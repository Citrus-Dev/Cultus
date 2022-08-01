# Inclinarse a medida que el ugador hace fuerza para un lado
# Cuando llegue a un maximo de tension, romper la cadena y bajar la jaula
# TODO hacer trigger que mande una señal cuando el jugador empuja en una direccion
# TODO hacer que un gib se pueda poner inactivo y despues activar (para la cadena)
class_name IntroJaula
extends StaticBody2D

var tension: float
var cayendo: bool

func _physics_process(delta):
	pass
