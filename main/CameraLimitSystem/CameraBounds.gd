class_name CameraBounds
extends CollisionShape2D

export(NodePath) var mask_node_path

var mask_node : Node2D # This node's visisblity will be toggled when the bounds are active

func _ready() -> void:
	if mask_node_path != "":
		mask_node = get_node(mask_node_path)


func get_new_limits(_instant := false):
	if get_tree().get_nodes_in_group("CamaraFalsa").size() == 0:
		# There's no camera
		return
	
	var limits_array = [0,0,0,0]
	var cam : Camera2D = get_tree().get_nodes_in_group("CamaraFalsa")[0]
	cam.current_active_bounds = self
	
	limits_array[0] = global_position.y - shape.extents.y # Top
	limits_array[1] = global_position.y + shape.extents.y # Bottom
	limits_array[2] = global_position.x - shape.extents.x # Left 
	limits_array[3] = global_position.x + shape.extents.x # Right
	
	if _instant:
		cam.tween_limits(limits_array, true)
		return
	
	cam.tween_limits(limits_array)
	toggle_mask_vis(false)


# Called when another bound is triggered
func stop_active():
	toggle_mask_vis(true)


func toggle_mask_vis(_bool : bool):
	if !mask_node: return
	
	var value = int(_bool)
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		mask_node,
		"modulate:a",
		mask_node.modulate.a,
		value,
		0.5
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	tween.call_deferred("free")

