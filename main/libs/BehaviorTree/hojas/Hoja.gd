class_name Hoja
extends BTBase

func _ready() -> void:
	if get_child_count() != 0:
		printerr("(%s) BEHAVIOR TREE ERROR: Una hoja no puede tener hijos." % [name]) 
