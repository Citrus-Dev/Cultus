extends Nivel 

const DATO_ENCUENTRO_TERMINADO := "encuentro_terminado"

export(NodePath) onready var spawn_rueda1 = get_node(spawn_rueda1) as SpawnerAuto
export(NodePath) onready var spawn_rueda2 = get_node(spawn_rueda2) as SpawnerAuto
export(NodePath) onready var spawn_rueda3 = get_node(spawn_rueda3) as SpawnerAuto

export(NodePath) onready var spawn_esqueleto1 = get_node(spawn_esqueleto1) as SpawnerAuto
export(NodePath) onready var spawn_esqueleto2 = get_node(spawn_esqueleto2) as SpawnerAuto
export(NodePath) onready var spawn_esqueleto3 = get_node(spawn_esqueleto3) as SpawnerAuto

export(NodePath) onready var puerta1 = get_node(puerta1) as Puerta
export(NodePath) onready var puerta2 = get_node(puerta2) as Puerta

export(NodePath) onready var area = get_node(area) as Area2D

var contador_enemigos: int



func _ready():
	if info_persist_nivel.has(DATO_ENCUENTRO_TERMINADO):
		puerta1.set_abierto(true)
		puerta2.set_abierto(true)
	else:
		area.connect("body_entered", self, "empezar_encuentro")
		for i in get_tree().get_nodes_in_group("spawners"):
			i.connect("spawn_muerto", self, "subir_contador")

func empezar_encuentro(__):
	spawn_rueda1.spawn()
	spawn_rueda2.spawn()
	spawn_rueda3.spawn()
	spawn_esqueleto1.spawn()
	spawn_esqueleto2.spawn()
	spawn_esqueleto3.spawn()

func subir_contador():
	contador_enemigos += 1
	if contador_enemigos == 6:
		terminar_encuentro()

func terminar_encuentro():
	info_persist_nivel[DATO_ENCUENTRO_TERMINADO] = true
	
	puerta1.abrir()
	puerta2.abrir()

