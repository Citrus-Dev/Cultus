# Platafroma que pierde colision despues d episarla por un tiempo, y vuelve con un timer
class_name PlataformaFragil
extends PlataformaAlterna

export(float) var tiempo_drop = .8 # El tiempo que tarda en desactivar despues que la pisas
export(float) var tiempo_recuperacion = 1.5 # El tiempo que tarda en volver

var timer_drop := Timer.new() 
var timer_recuperacion := Timer.new()
var pisando : bool

func _ready() -> void:
	timer_drop.one_shot = true
	timer_drop.wait_time = tiempo_drop
	add_child(timer_drop)
	timer_drop.connect("timeout", self, "drop")
	
	if tiempo_recuperacion != 0.0:
		timer_recuperacion.one_shot = true
		timer_recuperacion.wait_time = tiempo_recuperacion
		add_child(timer_recuperacion)
		timer_recuperacion.connect("timeout", self, "recuperar")


func _physics_process(delta: float) -> void:
	if timer_drop.is_stopped() and pisando:
		timer_drop.start()
	if !timer_drop.is_stopped():
		shaker.add_trauma(0.1)


func drop():
	alternar(false)
	if tiempo_recuperacion != 0.0: timer_recuperacion.start()


func recuperar():
	alternar(true)
