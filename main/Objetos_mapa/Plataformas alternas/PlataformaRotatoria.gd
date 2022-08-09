class_name PlataformaRotatoria
extends PlataformaAlterna

export(float) var velocidad_rotacion = 2.0
export(float) var tiempo_quieto = 3.0
export(float) var tiempo_temblar = 1.0
export(float) var intervalo_rotacion_grados = 180.0
export(bool) var invertir_dir 

var timer_stay := Timer.new() 
var timer_windup := Timer.new()

var girando : bool
var shake : bool
var proximo_intervalo : float

func _ready() -> void:
	timer_stay.wait_time = tiempo_quieto
	timer_stay.one_shot = true
	timer_stay.connect("timeout", self, "timer_stay_terminado")
	add_child(timer_stay)
	
	timer_windup.wait_time = tiempo_temblar
	timer_windup.one_shot = true
	timer_windup.connect("timeout", self, "timer_windup_terminado")
	add_child(timer_windup)
	
	calcular_proximo_intervalo()


# Termino la espera, empezar a sacudirse
func timer_stay_terminado():
	shake = true
	timer_windup.start()


# Termino de sacudirse, empezar a girar
func timer_windup_terminado():
	shake = false
	girando = true


func _process(delta: float) -> void:
	if shake:
		shaker.add_trauma(2.0 * delta)


func _physics_process(delta: float) -> void:
	var velocidad : float = delta * velocidad_rotacion * mult_dir()
	if girando:
		rotation += velocidad
		if rotation >= proximo_intervalo:
			rotation = proximo_intervalo
			girando = false
			calcular_proximo_intervalo()


func calcular_proximo_intervalo():
	proximo_intervalo = rotation + deg2rad(intervalo_rotacion_grados) * mult_dir()
	timer_stay.start()


func mult_dir() -> int:
	return -1 if invertir_dir else 1
