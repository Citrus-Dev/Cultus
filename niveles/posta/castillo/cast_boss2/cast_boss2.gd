extends Nivel

const NOMBRE_DATO := "boss_muerto"
const TIEMPO_POLILLAS := 6.0
const MAX_POLILLAS := 3

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_empezar_boss = get_node(trigger_empezar_boss) as TriggerOnce
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var spawner_boss = get_node(spawner_boss) as SpawnerAuto
export(NodePath) onready var spawner_pol_1 = get_node(spawner_pol_1) as SpawnerAuto
export(NodePath) onready var spawner_pol_2 = get_node(spawner_pol_2) as SpawnerAuto
export(NodePath) onready var puente = get_node(puente) as Node2D
export(NodePath) onready var plataforma_spawn_boss = get_node(plataforma_spawn_boss) as Node2D

var boss : Personaje
var tembleque : bool

var polillas_activas : bool
var polillas_totales : int
var polilla_timer : float

func _ready() -> void:
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_empezar_boss.connect("triggered", self, "empezar_boss")
		return


func _process(delta):
	if tembleque: temblar()
	procesar_polillas(delta)


func empezar_boss():
	puerta.cerrar()
	limites_camara_boss.get_new_limits()
	boss = spawner_boss.spawn()
	boss.connect("muerte_fachera_terminada", self, "terminar_boss")
	
	yield(get_tree().create_timer(1.2), "timeout")
	
	barra_hp.objetivo = boss
	barra_hp.set_activo(true)
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	sacar_plataforma_spawn_boss()
	boss.empezar_boss()
	
	empezar_timer_polillas()


func terminar_boss():
	primer_limite_camara_obj.get_new_limits()
	
	yield(get_tree().create_timer(0.5), "timeout")
	tembleque = true
	
	yield(get_tree().create_timer(2.0), "timeout")
	tembleque = false
	puente.destruir()


func temblar():
	var cam = get_tree().get_nodes_in_group("Camara")[0] as CamaraReal
	cam.aplicar_screenshake(10.0)


func sacar_plataforma_spawn_boss():
	for i in range(100):
		plataforma_spawn_boss.position.x += 1
		yield(get_tree(), "idle_frame")


func procesar_polillas(delta : float):
	if !polillas_activas: return
	if polilla_timer > 0:
		polilla_timer -= delta
	if polilla_timer <= 0:
		polilla_time()


func empezar_timer_polillas():
	polillas_activas = true
	polilla_timer = TIEMPO_POLILLAS


func polilla_time():
	if polillas_totales >= MAX_POLILLAS: return
	
	var rand : String = "spawner_pol_" + str((randi() % 1) + 1)
	var spawner = get(rand)
	var polilla = spawner.spawn()
	polilla.connect("muerto", self, "polilla_muerta")
	polillas_totales += 1
	empezar_timer_polillas()
	alertar_todos_los_enemigos()


func polilla_muerta():
	polillas_totales -= 1


