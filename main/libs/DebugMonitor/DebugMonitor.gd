extends Node2D

export(NodePath) var monitor_target_node
export(String) var monitor_target_property
export(String) var monitor_target_resource
export(String) var monitor_flavor_text
export(String) var get_by_group

onready var label = get_node("Label")

var target_by_group
var target_resource


func _init():
	if !OS.has_feature("debug"):
		call_deferred("free")


func _ready():
	if monitor_target_node != null:
		monitor_target_node = get_node(monitor_target_node)
	
	if get_by_group != "":
		yield(get_tree(), "idle_frame")
		target_by_group = get_tree().get_nodes_in_group(get_by_group)[0]
	
	if monitor_target_resource != "":
		var target_node 
		if get_by_group != "":
			target_node = target_by_group
		else:
			target_node = monitor_target_node
		
		target_resource = target_node.get(monitor_target_resource)


func _process(_delta):
	if is_instance_valid(target_by_group):
		set_label_text(target_by_group.get(monitor_target_property))
	
	if is_instance_valid(monitor_target_node):
		set_label_text(monitor_target_node.get(monitor_target_property))
	
	if target_resource != null:
		var value = target_resource.get(monitor_target_property)
		set_label_text(value)


func set_label_text(_info):
	label.text = monitor_flavor_text + ": " + str(_info)
