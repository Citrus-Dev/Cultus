extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var boss = get_node(boss) as Mimic
export(NodePath) onready var checkpoint_real = get_node(checkpoint_real) as Checkpoint
export(NodePath) onready var limites_boss = get_node(limites_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var pos_centro = get_node(pos_centro) as Position2D

func _ready():
	if !info_persist_nivel.has(NOMBRE_DATO):
		boss.connect("activado", self, "empezar_boss")
		boss.connect("muerto", self, "boss_muerto")
		boss.global_position = pos_centro.global_position
		return
	
	# Ya mataste al boss
	boss.call_deferred("free")
	mover_checkpoint_real()


func empezar_boss():
	limites_boss.get_new_limits()
	puerta.cerrar()


func boss_muerto():
	info_persist_nivel[NOMBRE_DATO] = true
	primer_limite_camara_obj.get_new_limits()
	puerta.abrir()
	mover_checkpoint_real()


func mover_checkpoint_real():
	checkpoint_real.global_position = pos_centro.global_position
