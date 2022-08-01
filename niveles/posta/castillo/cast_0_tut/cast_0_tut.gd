extends Nivel

const NOMBRE_DATO := "puerta_abierta"

export(NodePath) var path_spawner_cult
export(NodePath) var path_puertas
export(NodePath) var path_target_correr
export(NodePath) var path_trigger_rajar
export(NodePath) var path_arma

var spawner_cult : SpawnerAuto
var puertas : Puerta
var target_correr : Position2D
var trigger_rajar : Area2D
var arma : Node2D

var cultista_actor : Cultista

func _ready():
	spawner_cult = get_node(path_spawner_cult)
	puertas = get_node(path_puertas)
	target_correr = get_node(path_target_correr)
	trigger_rajar = get_node(path_trigger_rajar)
	arma = get_node(path_arma)
	
	trigger_rajar.connect("triggered", self, "rajemos")
	
	if info_persist_nivel.has(NOMBRE_DATO): 
		puertas.set_abierto(true)
		trigger_rajar.free()
		arma.free()
		return
	
	cultista_actor = spawner_cult.spawn()
	yield(get_tree(), "idle_frame")
	cultista_actor.set_es_actor(true)
	cultista_actor.script_idle({"Anim" : "idle", "FlipH" : true})


# El cultista ve al jugador y se va corriendo
func rajemos():
	yield(get_tree().create_timer(0.6), "timeout")
	cultista_actor.script_idle({
		"Anim" : "correr",
		"FlipH" : false, 
		"CorrerObj" : target_correr
		})


# El cultista desaparece de la escena
func chau(__):
	cultista_actor.call_deferred("free")


# Abris las puertas
func terminar_script():
	puertas.abrir()
	info_persist_nivel[NOMBRE_DATO] = true
