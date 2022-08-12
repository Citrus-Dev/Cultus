class_name EfectoCirculo
extends Node2D

var color: Color
var radio_final: float
var radio_actual: float
var duracion: float

var tween := Tween.new()

func _init(
		_color: Color,
		_radio_inicial: float,
		_radio_final: float,
		_duracion: float) -> void:
	color = _color
	radio_actual = _radio_inicial
	radio_final = _radio_final
	duracion = _duracion
	
	tween.connect("tween_all_completed", self, "terminar")


func _ready() -> void:
	add_child(tween)
	
	tween.interpolate_property(
		self,
		"radio_actual",
		radio_actual,
		radio_final,
		duracion,
		Tween.TRANS_LINEAR
	)
	tween.interpolate_property(
		self,
		"color:a",
		color.a,
		0,
		duracion,
		Tween.TRANS_QUINT
	)
	
	tween.start()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radio_actual, color)


func _process(delta: float) -> void:
	update()


func terminar():
	call_deferred("free")
