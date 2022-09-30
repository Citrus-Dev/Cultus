extends Nivel

const DATO_ENCUNTRO_TERMINADO := "TERMIADO EL ENCUENTRO"
const ENEMIGOS_MUERTOS_PARA_FASE_2 := 7
const ENEMIGOS_MUERTOS_PARA_TERMINAR := 5

export(NodePath) onready var cam_limites_2 = get_node(cam_limites_2) as CameraBounds
export(NodePath) onready var puertas_fase1 = get_node(puertas_fase1) as Puerta
export(NodePath) onready var puertas_fase2 = get_node(puertas_fase2) as Puerta
export(NodePath) onready var trigger_empezar = get_node(trigger_empezar) as TriggerOnce
export(NodePath) onready var trigger_empezar_fase2 = get_node(trigger_empezar_fase2) as TriggerOnce
export(NodePath) onready var puerta_salir = get_node(puerta_salir) as Puerta
export(NodePath) onready var palanca = get_node(palanca) as Palanca

export(NodePath) onready var spawn_rueda1 = get_node(spawn_rueda1) as SpawnerAuto
export(NodePath) onready var spawn_rueda2 = get_node(spawn_rueda2) as SpawnerAuto
export(NodePath) onready var spawn_rueda3 = get_node(spawn_rueda3) as SpawnerAuto

export(NodePath) onready var spawn_paladin = get_node(spawn_paladin) as SpawnerAuto

export(NodePath) onready var spawn_summoner = get_node(spawn_summoner) as SpawnerAuto

export(NodePath) onready var spawn_mason1 = get_node(spawn_mason1) as SpawnerAuto
export(NodePath) onready var spawn_mason2 = get_node(spawn_mason2) as SpawnerAuto

export(NodePath) onready var spawn_polilla1 = get_node(spawn_polilla1) as SpawnerAuto
export(NodePath) onready var spawn_polilla2 = get_node(spawn_polilla2) as SpawnerAuto
export(NodePath) onready var spawn_polilla3 = get_node(spawn_polilla3) as SpawnerAuto
export(NodePath) onready var spawn_polilla4 = get_node(spawn_polilla4) as SpawnerAuto
export(NodePath) onready var spawn_polilla5 = get_node(spawn_polilla5) as SpawnerAuto

var fase: int
var contador_spawns: int


func _ready():
	if info_persist_nivel.has(DATO_ENCUNTRO_TERMINADO):
		# El encuentro ya fue terminado
		trigger_empezar.call_deferred("free")
		trigger_empezar_fase2.call_deferred("free")
		palanca.set_usado(true)
		puerta_salir.set_abierto(true)
	else:
		# El encuentro no se termino
		trigger_empezar.connect("body_entered", self, "empezar_encuentro")
		trigger_empezar_fase2.connect("body_entered", self, "empezar_fase2")
		palanca.connect("activado", self, "abrir_puerta_final_boss")




func empezar_encuentro(__):
	trigger_empezar.disconnect("body_entered", self, "empezar_encuentro")
	puertas_fase1.cerrar()
	cam_limites_2.get_new_limits()
	
	fase = 1
	
	# Spawnear polillas y masones
	for mason_s in [spawn_mason1, spawn_mason2]:
		var mason: Shot = mason_s.spawn()
		mason.connect("muerto", self, "aumentar_contador")
	
	for pol_s in [spawn_polilla1, spawn_polilla2, spawn_polilla3, spawn_polilla4, spawn_polilla5]:
		var polilla: Polilla = pol_s.spawn()
		polilla.connect("muerto", self, "aumentar_contador")
	
	alertar_todos_los_enemigos()



func empezar_fase2(__):
	puertas_fase2.cerrar()
	trigger_empezar_fase2.call_deferred("free")
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	contador_spawns = 0
	fase = 2
	
	# Spawnear ruedas, el summoner y el moderfoker
	var summoner: Summoner = spawn_summoner.spawn()
	summoner.connect("muerto", self, "aumentar_contador")
	alertar_todos_los_enemigos()
	
	for rueda_s in [spawn_rueda1, spawn_rueda2, spawn_rueda3]:
		var rueda: Rueda = rueda_s.spawn()
		rueda.connect("muerto", self, "aumentar_contador")
	alertar_todos_los_enemigos()
	
	for i in range(2):
		var moderfoker: BossPaladin = spawn_paladin.spawn()
		moderfoker.connect("muerto", self, "aumentar_contador")
		yield(get_tree().create_timer(1.0), "timeout")
		moderfoker.empezar_boss()
		yield(get_tree().create_timer(0.6), "timeout")



func terminar_fase1():
	puertas_fase1.abrir()
	primer_limite_camara_obj.get_new_limits()


func terminar_encuentro():
	info_persist_nivel[DATO_ENCUNTRO_TERMINADO] = true
	
	puertas_fase2.abrir()




func aumentar_contador():
	contador_spawns += 1
	if fase == 1 and contador_spawns >= ENEMIGOS_MUERTOS_PARA_FASE_2:
		terminar_fase1()
	elif fase == 2 and contador_spawns >= ENEMIGOS_MUERTOS_PARA_TERMINAR:
		terminar_encuentro()



func abrir_puerta_final_boss():
	ControladorUi.mensaje_ui("Una puerta se abre en la iglesia...", 2.0, true)
	puerta_salir.abrir()
	
	TransicionesDePantalla.abrio_puerta_boss_final = true



