class_name BossFinal
extends Personaje

const ANGULO_TILT: float = deg2rad(4.0)

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var sprite_ojo = get_node(sprite_ojo) as Sprite
export(NodePath) var hitbox_path 


func _ready():
	hitbox = get_node(hitbox_path)


func _process(delta):
	skin.position.y = anim_levitar(skin.position.y, .1 * delta, 0.6)
	
	rotation = ANGULO_TILT * input.x



func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x
