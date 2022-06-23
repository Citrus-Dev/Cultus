extends Nivel

const NOMBRE_DATO := "hp_agarrada"

export(NodePath) onready var trigger_enemigos = get_node(trigger_enemigos) as Area2D
export(NodePath) onready var hp1 = get_node(hp1) as PickupHP
export(NodePath) onready var hp2 = get_node(hp2) as PickupHP
export(NodePath) onready var hp3 = get_node(hp3) as PickupHP

func _ready():
	if info_persist_nivel.has(NOMBRE_DATO):
		hp1.call_deferred("free")
		hp2.call_deferred("free")
		hp3.call_deferred("free")
		trigger_enemigos.call_deferred("free")
		return
	trigger_enemigos.connect("body_entered", self, "evento_gracioso")


func evento_gracioso(__):
	info_persist_nivel[NOMBRE_DATO] = true
	for i in get_tree().get_nodes_in_group("Spawn"):
		i.spawn()
	alertar_todos_los_enemigos()
	trigger_enemigos.call_deferred("free")
