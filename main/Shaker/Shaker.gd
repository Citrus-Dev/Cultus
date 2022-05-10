class_name Shaker
extends Node

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target_path  # Assign the node this component will shake
export(bool) var use_offset_value

var target : Node
onready var noise = OpenSimplexNoise.new()
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var noise_y = 0
var current_offset : Vector2
var base_position : Vector2


func _ready() -> void:
	if target == null:
		target = get_node(target_path)
	
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
	base_position = target.position


func _process(delta : float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0)


func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	target.rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	if !use_offset_value:
		current_offset.x = base_position.x + max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
		current_offset.y = base_position.y + max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
		target.position = current_offset
	else:
		target.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
		target.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
