class_name HUD
extends CanvasLayer

export(NodePath) onready var cont_cooldowns = get_node(cont_cooldowns) as Container

func _ready() -> void:
	add_to_group("HUD")


func instanciar_medidor_cooldown(inst):
	cont_cooldowns.add_child(inst)
