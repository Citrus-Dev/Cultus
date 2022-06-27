extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_empezar_boss = get_node(trigger_empezar_boss) as TriggerOnce
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss

func _ready() -> void:
	if !info_persist_nivel.has(NOMBRE_DATO):
		trigger_empezar_boss.connect("triggered", self, "empezar_boss")
		return


func empezar_boss():
	puerta.cerrar()
	limites_camara_boss.get_new_limits()
