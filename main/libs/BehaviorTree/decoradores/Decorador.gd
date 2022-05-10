class_name Decorador, "res://main/libs/BehaviorTree/icons/category_decorator.svg"
extends BTBase

var hijo : BTBase

func _ready() -> void:
	if get_child_count() != 1:
		printerr("(%s) BEHAVIOR TREE ERROR: Un decorador debe tener solo un hijo." % [name]) 
	hijo = get_child(0)
