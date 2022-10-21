extends Nivel 

const DATO_ENCUENTRO_TERMINADO := "encuentro_terminado"

export(NodePath) onready var spawn_rueda1 = get_node(spawn_rueda1) as SpawnerAuto

export(NodePath) onready var spawn_polilla1 = get_node(spawn_polilla1) as SpawnerAuto
export(NodePath) onready var spawn_polilla2 = get_node(spawn_polilla2) as SpawnerAuto
export(NodePath) onready var spawn_polilla3 = get_node(spawn_polilla3) as SpawnerAuto
export(NodePath) onready var spawn_polilla4 = get_node(spawn_polilla4) as SpawnerAuto

export(NodePath) onready var spawn_shot1 = get_node(spawn_shot1) as SpawnerAuto
export(NodePath) onready var spawn_shot2 = get_node(spawn_shot2) as SpawnerAuto

export(NodePath) onready var spawn_esqueleto1 = get_node(spawn_esqueleto1) as SpawnerAuto

export(NodePath) onready var puerta1 = get_node(puerta1) as Puerta
export(NodePath) onready var puerta2 = get_node(puerta2) as Puerta

export(NodePath) onready var area = get_node(area) as Area2D

var contador_enemigos: int
var oleada_actual: int = 1

func _ready():
	if info_persist_nivel.has(DATO_ENCUENTRO_TERMINADO):
		puerta1.set_abierto(true)
		puerta2.set_abierto(true)
	else:
		area.connect("body_entered", self, "empezar_encuentro")
		for i in get_tree().get_nodes_in_group("spawners"):
			i.connect("spawn_muerto", self, "subir_contador")

func empezar_encuentro(__):
	spawn_shot1.spawn()
	spawn_shot2.spawn()
	spawn_esqueleto1.spawn()

func empezar_oleada_2():
	oleada_actual = 2
	spawn_rueda1.spawn()
	spawn_polilla1.spawn()
	spawn_polilla2.spawn()
	spawn_polilla3.spawn()
	spawn_polilla4.spawn()

func subir_contador():
	contador_enemigos += 1
	if oleada_actual == 1 and contador_enemigos == 3:
		empezar_oleada_2()
		contador_enemigos = 0
	elif oleada_actual == 2 and contador_enemigos == 5:
		terminar_encuentro()
		contador_enemigos = 0
		
func terminar_encuentro():
	info_persist_nivel[DATO_ENCUENTRO_TERMINADO] = true
	
	puerta1.abrir()
	puerta2.abrir()

