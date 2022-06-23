class_name HUD
extends CanvasLayer

const CHECK_FADE_VELOCIDAD := 2.5

export(NodePath) onready var cont_cooldowns = get_node(cont_cooldowns) as Container
export(NodePath) onready var label_checkpoint = get_node(label_checkpoint) as Label

func _ready() -> void:
	add_to_group("HUD")
	label_checkpoint.visible = false
	ControladorUi.connect("partida_guardada", self, "mostrar_label_checkpoint")


func _process(delta):
	if label_checkpoint.visible == true:
		label_checkpoint.modulate.a -= delta * CHECK_FADE_VELOCIDAD


func instanciar_medidor_cooldown(inst):
	cont_cooldowns.add_child(inst)


func mostrar_label_checkpoint():
	label_checkpoint.visible = true
	label_checkpoint.modulate.a = 2.5
