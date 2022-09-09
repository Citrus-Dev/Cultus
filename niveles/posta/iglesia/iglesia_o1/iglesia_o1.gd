extends Nivel

const NOMBRE_DATO := "boss_muerto"
const ENEMIGOS := 5

export(NodePath) onready var trigger_encuentro = get_node(trigger_encuentro) as TriggerOnce
export(NodePath) onready var puerta = get_node(puerta) as Puerta

var enemigos_muertos: int
var spawners: Array

func _ready() -> void:
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_encuentro.connect("triggered", self, "empezar_encuentro")
		spawners = get_tree().get_nodes_in_group("spawners")
		for i in spawners:
			i.connect("spawn_muerto", self, "test_encuentro_terminado")
	else:
		trigger_encuentro.call_deferred("free")


func empezar_encuentro():
	puerta.cerrar()
	for i in spawners:
		i.spawn()
	alertar_todos_los_enemigos()


func encuentro_terminado():
	puerta.abrir()
	info_persist_nivel[NOMBRE_DATO] = true


func test_encuentro_terminado():
	enemigos_muertos += 1
	if enemigos_muertos >= ENEMIGOS:
		encuentro_terminado()

