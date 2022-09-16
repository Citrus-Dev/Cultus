class_name Summoner
extends Personaje

const MAX_SPAWNS: int = 4
const INTERVALO_SUMMON: float = 2.5
const ESCENA_SUMMON_RANDOM := preload("res://main/Personajes/Summoner/SummonRandom.tscn")

# Me canse de usar la maquina de estados de mierda, ahora los estados son un enum
# El que le joda que la haga!!!
enum Estados {
	IDLE,
	ALERTA,
	SUMMON,
	MUERTO
}

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

var estado_actual: int setget set_estado

# Spawnear un enemigo agrega a este numero
# Si es mas que MAX_SPAWNS no se puede spawnear mas
var peso_actual: int 

var timer_alerta: float

func _init():
	add_to_group("Enemigos")
	
	connect("objetivo_encontrado", self, "alertar")


func _ready():
	set_estado(estado_actual)


func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	
	# Si te ataca el jugador despertate (aunque este fuera del rango de deteccion)
	if _dmg.atacante is Personaje:
		objetivo = _dmg.atacante
		alertar()


func alertar():
	if !ciego and !muerto:
		set_estado(Estados.ALERTA)
		objetivo.connect("muerto", self, "perder_vista_jugador")
		add_to_group("EnemigosAlertados")


func set_estado(nuevo_estado: int):
	estado_actual = nuevo_estado
	match nuevo_estado:
		Estados.IDLE:
			animador.play("idle")
		Estados.ALERTA:
			animador.play("idle")
			timer_alerta = 0
			if objetivo.muerto:
				objetivo = null
				set_estado(Estados.MUERTO)
		Estados.SUMMON:
			animador.play("spawn")
			
			yield(animador, "animation_finished")
			
			set_estado(Estados.ALERTA)
		Estados.MUERTO:
			pass


func procesar_estado(delta: float):
	match estado_actual:
		Estados.IDLE:
			pass
		Estados.ALERTA:
			mirar_al_jugador()
			
			timer_alerta += delta
			if puede_spawnear() and timer_alerta >= INTERVALO_SUMMON:
				set_estado(Estados.SUMMON)
		Estados.SUMMON:
			pass
		Estados.MUERTO:
			pass


func _process(delta: float):
	procesar_estado(delta)


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	var tipo = _info.dmg_tipo


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		set_deferred("monitorable", false)
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
	cambiar_visibilidad(!toggle)
	set_estado(Estados.MUERTO)


func mirar_al_jugador():
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	var dir_a_jug = jug.global_position - global_position
	
	set_dir(sign(dir_a_jug.x))


func evento_anim_spawn():
	hacer_summon_random(global_position + Vector2.UP * 96)


func hacer_summon_random(pos: Vector2):
	var inst: SummonRandom = ESCENA_SUMMON_RANDOM.instance()
	inst.global_position = pos
	get_tree().root.add_child(inst)
	
	inst.connect("enemigo_spawneado", self, "al_spawnear_enemigo")
	inst.spawn_random()


func reducir_peso():
	peso_actual -= 1


func al_spawnear_enemigo(enemigo: Personaje):
	# Subirle al peso
	peso_actual += 1
	
	# Reducir el peso cuando lo maten
	enemigo.connect("muerto", self, "reducir_peso")


func puede_spawnear() -> bool:
	return bool(
		peso_actual < MAX_SPAWNS
	)









