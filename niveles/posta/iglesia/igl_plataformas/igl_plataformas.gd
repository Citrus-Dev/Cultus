extends Nivel

const DATO_PATH_OF_PAIN_ABIERTO := "abriste la entrada al path of pain"
const DATO_PATH_OF_PAIN_SALIDA := "abriste la salida al path of pain"
const DATO_PICKUP_AGARRADO := "agarraste la gauss"

export(NodePath) onready var puerta_pop_entrada = get_node(puerta_pop_entrada) as Puerta
export(NodePath) onready var puerta_pop_salida = get_node(puerta_pop_salida) as Puerta
export(NodePath) onready var pickup_gauss = get_node(pickup_gauss) 


func _ready():
	if info_persist_nivel.has(DATO_PATH_OF_PAIN_ABIERTO):
		puerta_pop_entrada.set_abierto(true)
	
	if info_persist_nivel.has(DATO_PATH_OF_PAIN_SALIDA):
		puerta_pop_salida.set_abierto(true)
	
	if info_persist_nivel.has(DATO_PICKUP_AGARRADO):
		pickup_gauss.call_deferred("free")
	else:
		pickup_gauss.connect("on_pickup", self, "gauss_agarrada")




func abrir_entrada_path_of_pain():
	info_persist_nivel[DATO_PATH_OF_PAIN_ABIERTO] = true
	puerta_pop_entrada.abrir()

func abrir_salida_path_of_pain():
	info_persist_nivel[DATO_PATH_OF_PAIN_SALIDA] = true
	puerta_pop_salida.abrir()

func gauss_agarrada():
	info_persist_nivel[DATO_PICKUP_AGARRADO] = true
