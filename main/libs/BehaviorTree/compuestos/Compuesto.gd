class_name Compuesto
extends BTBase

func _ready() -> void:
	if get_child_count() == 0:
		printerr("(%s) BEHAVIOR TREE ERROR: Un compuesto debe tener almenos un hijo." % [name]) 
