extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_empezar_boss = get_node(trigger_empezar_boss) as TriggerOnce
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var spawner_boss = get_node(spawner_boss) as SpawnerAuto

var boss : Personaje

func _ready() -> void:
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_empezar_boss.connect("triggered", self, "empezar_boss")
		return


func empezar_boss():
	puerta.cerrar()
	limites_camara_boss.get_new_limits()
	boss = spawner_boss.spawn()
	spawner_boss.connect("spawn_muerto", self, "terminar_boss")
	
	yield(get_tree().create_timer(1.2), "timeout")
	
	barra_hp.objetivo = boss
	barra_hp.set_activo(true)


func terminar_boss():
	primer_limite_camara_obj.get_new_limits()
