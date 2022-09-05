extends Nivel

const NOMBRE_DATO := "boss_muerto"

export(NodePath) onready var boss = get_node(boss) as Mimic
export(NodePath) onready var checkpoint_real = get_node(checkpoint_real) as Checkpoint
export(NodePath) onready var limites_boss = get_node(limites_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var pos_centro = get_node(pos_centro) as Position2D

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	
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
	
	timer.start(2.0)
	yield(timer, "timeout")
	
	mover_checkpoint_real()
	
	timer.start(2.0)
	yield(timer, "timeout")
	
	primer_limite_camara_obj.get_new_limits()
	puerta.abrir()


func mover_checkpoint_real():
	checkpoint_real.global_position = pos_centro.global_position
	var circ = EfectoCirculo.new(Color.white, 1.0, 256.0, 0.8)
	checkpoint_real.add_child(circ)
