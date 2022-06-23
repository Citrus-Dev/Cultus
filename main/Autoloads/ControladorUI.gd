extends Node

signal cambiar_salud(_cantidad)
signal balas_cambio(_cantidad)
signal partida_guardada

var jugador : Jugador
var hud : HUD
var medidor_balas : Control setget set_medidor_balas

var jug_hp : int

func _ready() -> void:
	connect("cambiar_salud", self, "actualizar_salud_jugador")


func actualizar_salud_jugador(_hp : int):
	jug_hp = _hp


func set_medidor_balas(_med : Control):
	medidor_balas = _med
