class_name HudBarraDeArmas
extends Control

const FADE_DURACION: float = 0.5

export(NodePath) onready var contenedor_paneles = get_node(contenedor_paneles) as Container

var timer_visible: Timer

func _ready() -> void:
	timer_visible = Timer.new()
	add_child(timer_visible)
	timer_visible.one_shot = true
	
	timer_visible.connect("timeout", self, "toggle_visible", [false])




func toggle_visible(toggle: bool):
	var t := Tween.new()
	add_child(t)
	
	t.interpolate_property(
		self,
		"modulate:a",
		modulate.a,
		1 if toggle else 0,
		FADE_DURACION
	)
	t.start()
	
	if toggle:
		timer_visible.start()
