extends Nivel

const NOMBRE_ENCUENTRO_DATO := "boss_muerto"

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds
export(NodePath) onready var trigger_boss = get_node(trigger_boss) as TriggerOnce
export(NodePath) onready var puerta1 = get_node(puerta1) as Puerta
export(NodePath) onready var puerta2 = get_node(puerta2) as Puerta
export(NodePath) onready var boss_spawn = get_node(boss_spawn) as SpawnerAuto
export(NodePath) onready var boss_barra_hp = get_node(boss_barra_hp) as BarraHPBoss

var focus_cam_boss : bool

func _ready():
	if info_persist_nivel.has(NOMBRE_ENCUENTRO_DATO):
		return
	else:
		trigger_boss.connect("triggered", self, "boss_spawn")
#		boss_spawn.connect("spawn_muerto", self, "boss_muerte")


func alternar_limites_boss(toggle : bool):
	focus_cam_boss = toggle
	if focus_cam_boss:
		cambiar_limites_camara(limites_camara_boss)
	else:
		cambiar_limites_camara(primer_limite_camara_obj)


func boss_spawn():
	puerta1.cerrar()
	puerta2.cerrar()
	alternar_limites_boss(true)
	yield(get_tree().create_timer(2, false), "timeout")
	# PUTO
	var inst = boss_spawn.spawn()
	inst.connect("muerto", self, "boss_muerte")
	boss_barra_hp.set_activo(true)


func boss_muerte():
	info_persist_nivel[NOMBRE_ENCUENTRO_DATO] = true
	
	yield(get_tree().create_timer(2.5, false), "timeout")
	puerta1.abrir()
	puerta2.abrir()
	alternar_limites_boss(false)
