extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var boss = get_node(boss) as EsqueletoPrime
export(NodePath) onready var limites_boss = get_node(limites_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_inicio = get_node(trigger_inicio) as TriggerOnce

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
	puerta.abrir()
