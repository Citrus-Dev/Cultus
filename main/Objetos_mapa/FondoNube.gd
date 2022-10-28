class_name FondoNube
extends Sprite

const VARIACION: float = 1.2

export var pos_x_minima: float
export var pos_x_maxima: float

export var velocidad_base: float

var vel: float



func _ready():
	randomize()
	vel = velocidad_base * rand_range(VARIACION * 0.5 , VARIACION)



func _process(delta):
	position.x += vel * delta
	if position.x > pos_x_maxima:
		position.x = pos_x_minima
