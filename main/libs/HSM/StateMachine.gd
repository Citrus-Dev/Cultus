class_name StateMachine
extends Node

signal state_changed(_statename)
signal state_left(_statename)

"""
Generic state machine. Initializes states and delegates engine callbacks 
(_physics_process, _ready, etc) to the active state.
"""

export var initial_state := NodePath()

onready var state = get_node(initial_state) setget set_state 
onready var _state_name = state.name

var enabled : bool


func _init() -> void:
	add_to_group("state_machine")


func _ready() -> void:
	yield(owner, "ready") # Wait for the owner node to finish initializing before doing anything.
	state.enter()


func _unhandled_input(event : InputEvent) -> void:
	state.unhandled_input(event)


func _process(delta : float) -> void: 
	state.process(delta)


func _physics_process(delta : float) -> void:
	state.physics_process(delta)


func transition_to(target_state_path : String, msg : Dictionary = {}) -> void:
	if !has_node(target_state_path):
		return
	if state.name == target_state_path:
		return
	
	emit_signal("state_changed", target_state_path)
	emit_signal("state_left", state.name)
	
	var target_state := get_node(target_state_path)
	
	state.exit()
	self.state = target_state
	state.enter(msg)


func set_state(value) -> void:
	state = value
	_state_name = state.name
