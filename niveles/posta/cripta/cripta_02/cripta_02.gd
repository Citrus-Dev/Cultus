extends Nivel

const DATO_PUERTA_ABIERTA := "puerta abierta"

export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var palanca = get_node(palanca) as Palanca

func _ready():
	if info_persist_nivel.has(DATO_PUERTA_ABIERTA):
		puerta.set_abierto(true)
		palanca.set_usado()
	else:
		palanca.connect("activado",self, "abrirPuerta")

func abrirPuerta():
	puerta.abrir()
	info_persist_nivel[DATO_PUERTA_ABIERTA]=true
