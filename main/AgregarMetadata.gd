class_name AgregarMetadata
extends Node

export(NodePath) var objetivo_path
export(Dictionary) var metadatos

var objetivo: Node

func _ready() -> void:
	if objetivo_path:
		objetivo = get_node(objetivo_path)
	else:
		objetivo = self

	for dato in metadatos:
		objetivo.set_meta(dato, metadatos[dato])
