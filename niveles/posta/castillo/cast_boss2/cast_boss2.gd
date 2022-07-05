extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_empezar_boss = get_node(trigger_empezar_boss) as TriggerOnce
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var spawner_boss = get_node(spawner_boss) as SpawnerAuto
export(NodePath) onready var puente = get_node(puente) as Node2D
export(NodePath) onready var plataforma_spawn_boss = get_node(plataforma_spawn_boss) as Node2D

var boss : Personaje
var tembleque : bool

func _ready() -> void:
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_empezar_boss.connect("triggered", self, "empezar_boss")
		return


func _process(delta):
	if tembleque: temblar()


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
