class_name TriggerChangeCamBounds
extends Area2D

export(bool) var is_horizontal

export(String) var cam_target_up
export(String) var cam_target_down
export(String) var cam_target_left
export(String) var cam_target_right

func detect_direction(_body : Jugador, _exit := false):
	if is_horizontal:
		var pos = global_position.y
		var player_pos = _body.global_position.y - _body.PLAYER_HEIGHT / 2
		if pos > player_pos:
			update_cam_target(cam_target_down)
		else:
			update_cam_target(cam_target_up)
	else:
		var pos = global_position.x
		var player_pos = _body.global_position.x
		if pos > player_pos:
			update_cam_target(cam_target_left if !_exit else cam_target_right)
		else:
			update_cam_target(cam_target_right if !_exit else cam_target_left)


func update_cam_target(_new_target_name : String):
	var new_target = get_parent().get_node(_new_target_name) as CameraBounds
	if new_target != null:
		new_target.get_new_limits()
	else:
		printerr("TriggerChangeCameraBounds error")
