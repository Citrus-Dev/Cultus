# Contar tres fases, terminar cada fase cuando se mueran todos los enemigos spawneados en la anterior
extends Nivel

signal terminar_encuentro

export(NodePath) onready var spawn_pol_1 = get_node(spawn_pol_1) as SpawnerAuto
export(NodePath) onready var spawn_pol_2 = get_node(spawn_pol_2) as SpawnerAuto
export(NodePath) onready var spawn_cult = get_node(spawn_cult) as SpawnerAuto

var fase_actual : int
var contador_fase : int
var cont_fase_objetivo : int

func _ready():
	spawn_pol_1.connect("spawn_muerto", self, "aumentar_contador")
	spawn_pol_2.connect("spawn_muerto", self, "aumentar_contador")
	spawn_cult.connect("spawn_muerto", self, "aumentar_contador")


func _process(delta):
	DebugDraw.set_text("fase_actual", fase_actual)
	DebugDraw.set_text("contador_fase", contador_fase)
	DebugDraw.set_text("cont_fase_objetivo", cont_fase_objetivo)


func fase1():
	cont_fase_objetivo = 2
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_pol_1.spawn()
	spawn_pol_2.spawn()


func fase2():
	cont_fase_objetivo = 3
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_cult.spawn()
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_cult.spawn()
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_cult.spawn()


func fase3():
	cont_fase_objetivo = 6
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_pol_1.spawn()
	spawn_pol_2.spawn()
	spawn_cult.spawn()
	yield(get_tree().create_timer(0.6), "timeout")
	spawn_pol_1.spawn()
	spawn_pol_2.spawn()
	spawn_cult.spawn()


func aumentar_contador():
	contador_fase += 1
	if contador_fase >= cont_fase_objetivo:
		sig_fase()


func sig_fase():
	contador_fase = 0
	fase_actual += 1
	var fase_func = "fase" + str(fase_actual)
	if has_method(fase_func):
		call(fase_func)
	else:
		emit_signal("terminar_encuentro")
