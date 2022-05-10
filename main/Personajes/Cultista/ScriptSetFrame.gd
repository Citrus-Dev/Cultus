extends State

export(NodePath) onready var sprite = get_node(sprite) as Sprite

func enter(msg : Dictionary = {}) -> void:
	if msg.has("Frame"):
		sprite.frame = msg["Frame"]
	if msg.has("FrameCoords"):
		sprite.frame_coords = msg["FrameCoords"]


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 
