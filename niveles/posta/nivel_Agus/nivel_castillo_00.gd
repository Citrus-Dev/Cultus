extends Nivel


export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var checkpoint = get_node(checkpoint) as Checkpoint

func _ready():
	checkpoint.connect("usado", puerta, "abrir", [], CONNECT_ONESHOT)
