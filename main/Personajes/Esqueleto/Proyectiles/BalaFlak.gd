class_name BalaFlak
extends Granada

const TIMER_QUIETO := 0.3

var speed : float
var timer_quieto : float

func _ready():
	timer_quieto = TIMER_QUIETO


func _process(delta):
	speed = velocity.length()
	if speed <= 25:
		timer_quieto -= delta
		if timer_quieto <= 0.0:
			call_deferred("free")
