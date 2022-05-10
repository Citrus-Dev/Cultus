class_name BlockinPolygon
extends Polygon2D
# Automatically adds a collision to the parent static body that matches this polygon

export var enable_collisions : bool
export var one_way : bool

func _ready() -> void:
	if !enable_collisions:
		return
	
	var parent = get_parent()
	var collider := CollisionPolygon2D.new()
#	collider.visible = false
	collider.global_position = position
	collider.polygon = polygon
	collider.one_way_collision = one_way
	parent.call_deferred("add_child", collider)
	uv = polygon
