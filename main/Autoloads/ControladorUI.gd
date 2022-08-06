extends Node

const OVERLAY_MUERTE_ESCENA = preload("res://main/UI/OverlayMuerte/OverlayMuerte.tscn")

signal cambiar_salud(_cantidad)
signal balas_cambio(_cantidad)
signal mensaje_ui(mensaje, tiempo, no_brillo)

var jugador : Personaje
var hud
var medidor_balas : Control setget set_medidor_balas

var jug_hp : int

func _ready() -> void:
	connect("cambiar_salud", self, "actualizar_salud_jugador")
	GameState.connect("jugador_muerto", self, "instanciar_overlay_muerte")


func actualizar_salud_jugador(_hp : int):
	jug_hp = _hp


func set_medidor_balas(_med : Control):
	medidor_balas = _med


func mensaje_ui(mensaje : String, tiempo := 1.4, no_brillo := false):
	emit_signal(mensaje, tiempo, no_brillo)


func instanciar_overlay_muerte():
	get_tree().root.add_child(OVERLAY_MUERTE_ESCENA.instance())



