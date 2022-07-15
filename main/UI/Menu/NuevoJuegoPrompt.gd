class_name NuevoJuegoPrompt
extends NinePatchRect

signal aceptado
signal cancelado

export(NodePath) onready var boton_aceptar = get_node(boton_aceptar) as TextureButton
export(NodePath) onready var boton_cancelar = get_node(boton_cancelar) as TextureButton

func _ready():
	boton_aceptar.connect("pressed", self, "emit_signal", ["aceptado"])
	boton_cancelar.connect("pressed", self, "emit_signal", ["cancelado"])
