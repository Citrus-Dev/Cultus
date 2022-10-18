class_name BossFinal
extends Personaje

const ANGULO_TILT: float = deg2rad(0.1)
const DISTANCIA_DEL_CENTRO_PARA_CAMBIAR: float = 200.0
const COOLDOWN_ATAQUE_LLUVIA: float = 10.0

const ATAQUES: Array = [
	"rayo",
	"rayo",
	"lluvia"
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


func esperar_random() -> float: return rand_range(1.5, 3.0)



func _init():
	add_to_group("Enemigos")
	add_to_group("Boss")
	connect("objetivo_encontrado", self, "alertar")


func _ready():
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
	
	decidir_siguiente_ataque()


func _process(delta):
	skin.position.y = anim_levitar(skin.position.y, .1 * delta, 0.6)
	
	rotation = ANGULO_TILT * (velocity.x)
	input.x = mult_actual
	
	if tembleque: shaker.add_trauma(0.5)


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
# - Spawnear enemigos para que te den balas (ojos?? polillas????)
# - Sacudir toda la arena y hacer que caigan piedras del techo. Las piedras dan municion.
func decidir_siguiente_ataque(ataque = "?"):
	timer_espera.start( esperar_random() )
	yield( timer_espera, "timeout" )
	
	if muerto:
		return
	
	var eleccion = ataque if ATAQUES.has(ataque) else ATAQUES[randi() % ATAQUES.size()]
	
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







