class_name HUD
extends CanvasLayer

const CHECK_FADE_VELOCIDAD := 2.5

export(NodePath) onready var cont_cooldowns = get_node(cont_cooldowns) as Container
export(NodePath) onready var label_checkpoint = get_node(label_checkpoint) as Label

var timer_mensaje : float

func _ready() -> void:
	add_to_group("HUD")
	label_checkpoint.visible = false
	ControladorUi.connect("mensaje_ui", self, "mostrar_mensaje")


func _process(delta):
	if label_checkpoint.visible == true:
		timer_mensaje -= delta
		if label_checkpoint.modulate.a > timer_mensaje:
			label_checkpoint.modulate.a -= delta * CHECK_FADE_VELOCIDAD
		if timer_mensaje <= 0:
			label_checkpoint.visible = false


func instanciar_medidor_cooldown(inst):
	cont_cooldowns.add_child(inst)


func mostrar_mensaje(mensaje : String = "??", tiempo := 2.5, no_brillo := false):
	label_checkpoint.visible = true
	timer_mensaje = tiempo
	label_checkpoint.text = mensaje
	label_checkpoint.modulate.a = 1.0 if no_brillo else tiempo 

