class_name BossFinal
extends Personaje

const ANGULO_TILT: float = deg2rad(0.1)
const DISTANCIA_DEL_CENTRO_PARA_CAMBIAR: float = 200.0
const COOLDOWN_ATAQUE_LLUVIA: float = 10.0

const ESCENA_SPAWNER_HILERAS_BOMBAS := preload("res://main/Personajes/Bosses/bossf/hilera_bombas/SpawnerDeHilera.tscn")

const ATAQUES: Array = [
	"rayo",
	"rayo",
	"rayo",
	"rayo",
	"lluvia",
	"bombas",
	"pilares",
	"pilares",
]


signal hacer_ataque_lluvia_piedras
signal muerto_enserio

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var sprite_ojo = get_node(sprite_ojo) as Sprite
export(NodePath) onready var anim_ataques = get_node(anim_ataques) as AnimationPlayer
export(NodePath) onready var shaker = get_node(shaker) as Shaker
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) var hitbox_path 

var pos_spawn: Vector2
var mult_actual: int = 1.0

var timer_espera: Timer
var timer_cooldown_lluvia: Timer

var muerto_enserio: bool
var tembleque: bool
var jugref: Personaje

var altura_inicial: float
var ataques_actuales: Array


func esperar_random() -> float: return rand_range(1.5, 3.0)



func _init():
	add_to_group("Enemigos")
	add_to_group("Boss")
	connect("objetivo_encontrado", self, "alertar")


func _ready():
	jugref = get_tree().get_nodes_in_group("Jugador")[0]
	
	Musica.set_override(Musica.Tracks.MUS_COMBATE)
	
	pos_spawn = global_position
	hitbox = get_node(hitbox_path)
	anim_ataques.connect("animation_finished", self, "decidir_siguiente_ataque")
	connect("hacer_ataque_lluvia_piedras", get_parent().get_node("LluviaPiedras"), "llover")
	connect("muerto_enserio", get_parent(), "boss_muerto")

	timer_espera = Timer.new()
	timer_espera.one_shot
	add_child(timer_espera)
	
	timer_cooldown_lluvia = Timer.new()
	timer_cooldown_lluvia.one_shot
	add_child(timer_cooldown_lluvia)
	
	altura_inicial = global_position.y
	
	decidir_siguiente_ataque()


func _process(delta):
	skin.position.y = anim_levitar(skin.position.y, .1 * delta, 0.6)
	
	rotation = ANGULO_TILT * (velocity.x)
	input.x = mult_actual
	
	if tembleque: shaker.add_trauma(0.5)
	
	# Hacemos que se acerque siempre a la altura inicial
	var dir: int = sign(global_position.y - altura_inicial)
	input.y = dir


func _physics_process(delta):
	# Moverse de un lado al otro
	# Hay una mejor forma de hacer esto
	# Lamentablemente no me importa
	var distancia_al_spawn = (global_position - pos_spawn).x * mult_actual
	if mult_actual == 1.0:
		if (distancia_al_spawn) * mult_actual > DISTANCIA_DEL_CENTRO_PARA_CAMBIAR * mult_actual:
			mult_actual *= -1
	elif mult_actual == -1.0:
		if (distancia_al_spawn) * mult_actual < DISTANCIA_DEL_CENTRO_PARA_CAMBIAR * mult_actual:
			mult_actual *= -1
	






func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x





func hacer_ataque( nombre: String ):
	anim_ataques.play(nombre)




# Ataques:
# - Laser con el ojo (va de un extremo del cuarto al otro)
# - Sacudir toda la arena y hacer que caigan piedras del techo. Las piedras dan municion.
# - Hilo de bombas
# - Pilares
func decidir_siguiente_ataque(ataque = "?"):
	timer_espera.start( esperar_random() )
	yield( timer_espera, "timeout" )
	
	if muerto:
		return
	
	var eleccion: String
	
	if ATAQUES.has(ataque):
		eleccion = ataque
	else:
		if ataques_actuales.empty():
			ataques_actuales = ATAQUES.duplicate()
		
		var randinex: int = randi() % ataques_actuales.size()
		eleccion = ataques_actuales[randinex]
		ataques_actuales.remove(randinex)
	
	
	match eleccion:
		"rayo":
			# Random rasho_lase1 o 2
			hacer_ataque("rasho_lase" + str(randi() % 2 + 1))
		"lluvia":
			
			if not timer_cooldown_lluvia.is_stopped():
				# No podemos hacer este ataque porque esta en cooldown, hace el rayo
				decidir_siguiente_ataque( "rayo" )
			
			# El ataque no lo hace el boss en si, solo emite una señal
			# En ready conectamos esta señal al objeto que va a hacer enserio la lluvia de piedras
			emit_signal("hacer_ataque_lluvia_piedras")
			
			timer_cooldown_lluvia.start(COOLDOWN_ATAQUE_LLUVIA)
			
			# No usa animador, llamamos esta funcion manualmente
			call_deferred("decidir_siguiente_ataque")
		
		"bombas":
			# Hacemos un windup temblando y esperando unos segundos
			tembleque = true
			timer_espera.start( 1.5 )
			yield(timer_espera, "timeout")
			tembleque = false
			
			# Sacar si el jugador esta a la izquierda o la derecha
			var dirjug: int = sign(jugref.global_position.x - global_position.x)
			
			# Spawnear el objeto que hace la hilera de bombas
			var obj: Node2D = ESCENA_SPAWNER_HILERAS_BOMBAS.instance()
			var angulo_random: float = rand_range(-12.0, 12.0)
			obj.rotation = deg2rad( dirjug + angulo_random + (180.0 if dirjug == -1 else 0.0) )
			obj.global_position = global_position
			get_parent().add_child(obj)
			
			# No usa animador, llamamos esta funcion manualmente
			call_deferred("decidir_siguiente_ataque")
		
		"pilares":
			get_tree().call_group("bossf_pilares", "activar")
			
			# No usa animador, llamamos esta funcion manualmente
			call_deferred("decidir_siguiente_ataque")


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hitbox.set_deferred("monitorable", false)
		hitbox.collision_mask = 0 
#	instanciar_ragdoll()
#	cambiar_visibilidad(!toggle)



func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	barra_hp.borrar_barra()
	tembleque = true
	
	timer_espera.start(4.0)
	yield(timer_espera, "timeout")
	
	morir_enserio()


func morir_enserio():
	emit_signal("muerto_enserio")
	
	tembleque = false
	muerto_enserio = true
	set_process(false)
	set_physics_process(false)
	
	for i in get_children(): i.queue_free()







