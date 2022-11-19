extends Nivel

const NOMBRE_DATO := "slide_agarrado"

export(NodePath) onready var spawn_polilla1 = get_node(spawn_polilla1) as SpawnerAuto
export(NodePath) onready var spawn_polilla2 = get_node(spawn_polilla2) as SpawnerAuto
export(NodePath) onready var spawn_polilla3 = get_node(spawn_polilla3) as SpawnerAuto
export(NodePath) onready var spawn_polilla4 = get_node(spawn_polilla4) as SpawnerAuto

export(NodePath) onready var cultista_forro1 = get_node(cultista_forro1) as Cultista
export(NodePath) onready var cultista_forro2 = get_node(cultista_forro2) as Cultista

export(NodePath) onready var trigger_polillas = get_node(trigger_polillas) as TriggerOnce
export(NodePath) onready var slide_pickup = get_node(slide_pickup) as PickupSkill
export(NodePath) onready var puerta_pickup = get_node(puerta_pickup) as Puerta

var contador_kills_abrir_puerta : int = 6

func _ready() -> void:
	if info_persist_nivel.has(NOMBRE_DATO): 
		slide_pickup.call_deferred("free")
		puerta_pickup.set_abierto(true)
	else:
		trigger_polillas.connect("triggered", self, "spawnear_polillas")
		cultista_forro1.connect("muerto", self, "enemigo_puerta_muerto")
		cultista_forro2.connect("muerto", self, "enemigo_puerta_muerto")
		slide_pickup.connect("agarrado", self, "guardar_slide")


func spawnear_polillas():
	spawn_polilla1.spawn()
	spawn_polilla2.spawn()
	spawn_polilla3.spawn()
	spawn_polilla4.spawn()


func enemigo_puerta_muerto():
	contador_kills_abrir_puerta -= 1
	if contador_kills_abrir_puerta == 0:
		abrir_puerta()


func abrir_puerta():
	puerta_pickup.abrir()


func guardar_slide():
	info_persist_nivel[NOMBRE_DATO] = true

