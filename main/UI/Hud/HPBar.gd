class_name HPBar
extends Control

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress

var tween_progress := Tween.new()

func _ready() -> void:
	add_child(tween_progress)
	
	ControladorUi.connect("cambiar_salud", self, "cambiar_valor")
	progress_bar.value = ControladorUi.jug_hp


func cambiar_valor(_hp : int):
	tween_progress.stop_all()
	tween_progress.interpolate_property(
		progress_bar,
		"value",
		progress_bar.value,
		_hp,
		.2,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween_progress.start()
