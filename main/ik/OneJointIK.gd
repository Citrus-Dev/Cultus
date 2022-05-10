extends Node
class_name OneJointIK

export var model_root : NodePath

export var upper_bone_node : NodePath setget set_upper_bone
export var lower_bone_node : NodePath setget set_lower_bone
export var terminus_node : NodePath setget set_terminus

export var reverse_joint : bool setget set_joint_sign

export var joint_extend_limit : float = 20 setget set_extend_limit
export var joint_fold_limit : float = 160 setget set_fold_limit

export var pin_terminus_rotation : bool

export var contact_margin : float = 1.0

onready var model = get_node(model_root) if model_root else null

onready var upper_bone = get_node(upper_bone_node) if upper_bone_node else null
onready var lower_bone = get_node(lower_bone_node) if lower_bone_node else null
onready var terminus = get_node(terminus_node) if terminus_node else null

var joint_sign : float = 1.0
var joint_offset : float = 0.0

var extend_limit : float
var fold_limit : float

var unreached_distance : float = 100.0

var config_warning = ""

var readied = false

func _ready():
	if not lower_bone.get_parent() == upper_bone or not terminus.get_parent() == lower_bone:
		print(name, " does not have a valid IK chain and has failed to initialize.")
	else:
		joint_offset = get_joint_offset()
		set_extend_limit(joint_extend_limit)
		set_fold_limit(joint_fold_limit)
		set_joint_sign(reverse_joint)
		readied = true


func reach_toward(coordinate : Vector2):
	if not readied or not model or not upper_bone or not lower_bone or not terminus:
		print(name, " does not have a valid IK chain and has de-initialized.")
		readied = false
		return
	var terminus_rotation = terminus.global_rotation
	var distance = upper_bone.global_position.distance_to(coordinate)
	var upper_length = lower_bone.position.length()
	var lower_length = terminus.position.length()
	distance = clamp(distance, abs(upper_length - lower_length) + 0.0001, (upper_length + lower_length) - 0.0001)
	var upper_squared = upper_length * upper_length
	var lower_squared = lower_length * lower_length
	var distance_squared = distance * distance
	lower_bone.rotation = (PI - joint_offset) - acos((upper_squared + lower_squared - distance_squared) / (2 * upper_length * lower_length))
	lower_bone.rotation = clamp(lower_bone.rotation, extend_limit, fold_limit)
	lower_bone.rotation = abs(lower_bone.rotation) * joint_sign
	var alpha_vector = terminus.global_position - upper_bone.global_position
	var goal_vector = coordinate - upper_bone.global_position
	var rotate_by = alpha_vector.angle_to(goal_vector) * sign(model.scale.x)
	upper_bone.global_rotation += rotate_by
	if pin_terminus_rotation:
		terminus.global_rotation = terminus_rotation
	unreached_distance = (terminus.global_position - coordinate).length()


func is_making_contact():
	return unreached_distance < contact_margin


func get_joint_offset():
	var previous_rotation = lower_bone.rotation
	lower_bone.rotation = 0.0
	var true_upper = lower_bone.global_position - upper_bone.global_position
	var true_lower = terminus.global_position - lower_bone.global_position
	var offset_angle = true_upper.angle_to(true_lower)
	lower_bone.rotation = previous_rotation
	return offset_angle


func set_upper_bone(path):
	upper_bone_node = path
	if readied:
		upper_bone = get_node(upper_bone_node)

func set_lower_bone(path):
	lower_bone_node = path
	if readied:
		lower_bone = get_node(lower_bone_node)

func set_terminus(path):
	terminus_node = path
	if readied:
		terminus = get_node(terminus_node)

func set_extend_limit(degrees):
	joint_extend_limit = clamp(abs(degrees), 1.0, 179.0)
	extend_limit = deg2rad(joint_extend_limit)
	if extend_limit >= fold_limit:
		config_warning = "Extend Limit must be less than Fold Limit!"

func set_fold_limit(degrees):
	joint_fold_limit = clamp(abs(degrees), 1.0, 179.0)
	fold_limit = deg2rad(joint_fold_limit)
	if fold_limit <= extend_limit:
		config_warning = "Fold Limit must be greater than Extend Limit!"

func set_joint_sign(reverse):
	reverse_joint = reverse
	if reverse_joint:
		joint_sign = -1.0
	else:
		joint_sign = 1.0


func _get_configuration_warning():
	return config_warning
