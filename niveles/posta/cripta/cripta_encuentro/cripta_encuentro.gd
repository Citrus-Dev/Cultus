extends Nivel

const DATO_ARMA_AGARRADA := "arma_agarrada"
const DATO_ENCUENTRO_TERMINADO := "encuentro_terminado"

signal ola_1_terminada
signal ola_2_terminada

export(NodePath) onready var spawn_rueda1 = get_node(spawn_rueda1) as SpawnerAuto
export(NodePath) onready var spawn_rueda2 = get_node(spawn_rueda2) as SpawnerAuto
export(NodePath) onready var spawn_rueda3 = get_node(spawn_rueda3) as SpawnerAuto
export(NodePath) onready var spawn_rueda4 = get_node(spawn_rueda4) as SpawnerAuto
export(NodePath) onready var spawn_esqueleto1 = get_node(spawn_esqueleto1) as SpawnerAuto
export(NodePath) onready var spawn_esqueleto2 = get_node(spawn_esqueleto2) as SpawnerAuto
export(NodePath) onready var spawn_mason = get_node(spawn_mason) as SpawnerAuto

export(NodePath) onready var puerta1 = get_node(puerta1) as Puerta
export(NodePath) onready var puerta2 = get_node(puerta2) as Puerta

export(NodePath) onready var pickup_ballesta = get_node(pickup_ballesta) as PickupArma

var contador_enemigos: int
var oleada_actual: int = 1


func _ready():
	if info_persist_nivel.has(DATO_ARMA_AGARRADA):
		pickup_ballesta.call_deferred("free")
	
	if info_persist_nivel.has(DATO_ENCUENTRO_TERMINADO):
		puerta1.set_abierto(true)
		puerta2.set_abierto(true)
	else:
		pickup_ballesta.connect("on_pickup", self, "empezar_encuentro")
		
		for i in get_tree().get_nodes_in_group("spawners"):
			i.connect("spawn_muerto", self, "subir_contador")



func empezar_encuentro():
	info_persist_nivel[DATO_ARMA_AGARRADA] = true
	
	puerta1.cerrar()
	puerta2.cerrar()
	
	spawn_rueda1.spawn()
	spawn_rueda2.spawn()
	spawn_rueda3.spawn()
	spawn_rueda4.spawn()


func empezar_oleada_2():
	oleada_actual = 2
	
	spawn_esqueleto1.spawn()
	spawn_esqueleto2.spawn()
	spawn_mason.spawn()


func termianr_encuentro():
	info_persist_nivel[DATO_ENCUENTRO_TERMINADO] = true
	
	puerta1.abrir()
	puerta2.abrir()


func subir_contador():
	contador_enemigos += 1
	
	if oleada_actual == 1 and contador_enemigos == 4:
		empezar_oleada_2()
		contador_enemigos = 0
	elif oleada_actual == 2 and contador_enemigos == 3:
		termianr_encuentro()
		contador_enemigos = 0

