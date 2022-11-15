extends Nivel

const NOMBRE_DATO := "boss_muerto"
const ESCENA_LLAVE := preload("res://main/Pickups/PickupLlaveIglesia.tscn")
const ESCENA_BUFANDA := preload("res://main/Pickups/skills/PickupBufanda.tscn")

export(NodePath) onready var boss = get_node(boss) as EsqueletoPrime
export(NodePath) onready var limites_boss = get_node(limites_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_inicio = get_node(trigger_inicio) as TriggerOnce
export(NodePath) onready var pos_spawn_bufan = get_node(pos_spawn_bufan) as Position2D
export(NodePath) onready var pos_spawn_llave = get_node(pos_spawn_llave) as Position2D

var pickups_agarrados: int

func _ready():
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_inicio.connect("triggered", self, "empezar_boss")
		return
	
	# Ya mataste al boss
	boss.call_deferred("free")



func empezar_boss():
	limites_boss.get_new_limits()
	boss.animador.play("emerger")
	puerta.cerrar()


func terminar_boss():
	info_persist_nivel[NOMBRE_DATO] = true
	primer_limite_camara_obj.get_new_limits()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	spawnear_drops()


# Spawnear la bufanda y la llave
# Solo abrir las puertas si se agarraron las dos
func spawnear_drops():
	var bufan = ESCENA_BUFANDA.instance()
	var llave = ESCENA_LLAVE.instance()
	
	pos_spawn_bufan.add_child(bufan)
	pos_spawn_llave.add_child(llave)
	
	bufan.connect("agarrado", self, "pickup_agarrado")
	llave.connect("agarrado", self, "pickup_agarrado")



func pickup_agarrado():
	pickups_agarrados += 1
	if pickups_agarrados == 2:
		abrir_puertas()





func abrir_puertas():
	puerta.abrir()
