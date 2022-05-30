extends Nivel

const NOMBRE_DATO := "puerta_abierta"

export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var checkpoint = get_node(checkpoint) as Checkpoint

func _ready():
	if info_persist_nivel.has(NOMBRE_DATO): 
		puerta.set_abierto(true)
		return
	checkpoint.connect("usado", self, "abrir_puerta", [], CONNECT_ONESHOT)


func abrir_puerta():
	puerta.abrir()
	info_persist_nivel[NOMBRE_DATO] = true
