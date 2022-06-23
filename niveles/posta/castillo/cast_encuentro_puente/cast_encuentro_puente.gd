extends Nivel

const NOMBRE_DATO := "encuentro_terminado"
const NOMBRE_DATO_PICKUP := "escopeta_agarrada"

export(NodePath) onready var puerta_izq = get_node(puerta_izq) as Puerta
export(NodePath) onready var puerta_der = get_node(puerta_der) as Puerta
export(NodePath) onready var escopeta = get_node(escopeta) as PickupArma
export(NodePath) onready var trigger_encuentro = get_node(trigger_encuentro) as TriggerOnce

export(NodePath) onready var spawn_l_1 = get_node(spawn_l_1) as SpawnerAuto
export(NodePath) onready var spawn_l_2 = get_node(spawn_l_2) as SpawnerAuto
export(NodePath) onready var spawn_l_3 = get_node(spawn_l_3) as SpawnerAuto
export(NodePath) onready var spawn_r_1 = get_node(spawn_r_1) as SpawnerAuto
export(NodePath) onready var spawn_r_2 = get_node(spawn_r_2) as SpawnerAuto
export(NodePath) onready var spawn_r_3 = get_node(spawn_r_3) as SpawnerAuto

var kills_para_terminar_oleada : int
var contador_kills_actual : int
var oleada_actual := 1

func _ready():
	if info_persist_nivel.has(NOMBRE_DATO_PICKUP):
		# Se agarro la escopeta, borrarla
		escopeta.call_deferred("free")
		trigger_encuentro.connect("triggered", self, "comenzar_encuentro")
	else:
		escopeta.connect("on_pickup", self, "registrar_escopeta_agarrada")
	
	if info_persist_nivel.has(NOMBRE_DATO):
		# Ya se hizo el encuentro, abrir la puerta del final
		puerta_der.set_abierto(true)
		trigger_encuentro.call_deferred("free")
	
	conectar_spawns_a_contador()


func _process(delta):
	DebugDraw.set_text("info_persist_nivel", info_persist_nivel.has(NOMBRE_DATO))
	DebugDraw.set_text("kills_para_terminar_oleada", kills_para_terminar_oleada)
	DebugDraw.set_text("contador_kills_actual", contador_kills_actual)
	DebugDraw.set_text("oleada_actual", oleada_actual)


func registrar_escopeta_agarrada():
	info_persist_nivel[NOMBRE_DATO_PICKUP] = true
	comenzar_encuentro()


func comenzar_encuentro():
	puerta_izq.cerrar()
	puerta_der.cerrar()
	yield(get_tree().create_timer(1), "timeout")
	spawnear_caballeros()


func terminar_encuentro():
	info_persist_nivel[NOMBRE_DATO] = true
	Musica.cambiar_musica(Musica.Tracks.MUS_NORMAL)
	puerta_izq.abrir()
	puerta_der.abrir()


func conectar_spawns_a_contador():
	var spawns := [
		spawn_l_1,
		spawn_l_2,
		spawn_l_3,
		spawn_r_1,
		spawn_r_2,
		spawn_r_3,
	]
	
	for s in spawns:
		s.connect("spawn_muerto", self, "aumentar_contador_enemigos")


func aumentar_contador_enemigos():
	contador_kills_actual += 1
	if contador_kills_actual >= kills_para_terminar_oleada:
		if oleada_actual == 1:
			oleada_actual = 2
			oleada_2()
		elif oleada_actual == 2:
			terminar_encuentro()


func spawnear_polillas():
	kills_para_terminar_oleada += 4
	spawn_l_1.spawn()
	spawn_l_3.spawn()
	spawn_r_1.spawn()
	spawn_r_3.spawn()
	alertar_todos_los_enemigos()


func spawnear_caballeros():
	kills_para_terminar_oleada += 2
	spawn_l_2.spawn()
	spawn_r_2.spawn()
	alertar_todos_los_enemigos()


func oleada_2():
	kills_para_terminar_oleada = 0
	contador_kills_actual = 0
	yield(get_tree().create_timer(0.8), "timeout")
	spawnear_polillas()
	spawnear_caballeros()
	yield(get_tree().create_timer(0.8), "timeout")
	spawnear_polillas()
	yield(get_tree().create_timer(0.4), "timeout")
	spawnear_polillas()



