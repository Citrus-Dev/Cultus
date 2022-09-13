extends Nivel

const DATO_GUARDADO := "pickup agarrado"

export(NodePath) onready var pickup = get_node(pickup)

func _ready():
	if info_persist_nivel.has(DATO_GUARDADO):
		pickup.call_deferred("free")
	else:
		pickup.connect("agarrado", self, "pickup_agarrado")


func pickup_agarrado():
	info_persist_nivel[DATO_GUARDADO] = true
