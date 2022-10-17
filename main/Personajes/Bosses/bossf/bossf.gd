class_name BossFinal
extends Personaje

const ANGULO_TILT: float = deg2rad(0.1)
const DISTANCIA_DEL_CENTRO_PARA_CAMBIAR: float = 200.0
	
const ATAQUES: Array = [
	"rayo"
]

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var sprite_ojo = get_node(sprite_ojo) as Sprite
export(NodePath) onready var anim_ataques = get_node(anim_ataques) as AnimationPlayer
export(NodePath) var hitbox_path 

var pos_spawn: Vector2
var mult_actual: int = 1.0

var timer_espera: Timer


func esperar_random() -> float: return rand_range(1.5, 3.0)



func _init():
	add_to_group("Enemigos")
	add_to_group("Boss")
	connect("objetivo_encontrado", self, "alertar")


func _ready():
	pos_spawn = global_position
	hitbox = get_node(hitbox_path)
	anim_ataques.connect("animation_finished", self, "decidir_siguiente_ataque")
	
	timer_espera = Timer.new()
	timer_espera.one_shot
	add_child(timer_espera)
	
	decidir_siguiente_ataque()


func _process(delta):
	skin.position.y = anim_levitar(skin.position.y, .1 * delta, 0.6)
	
	rotation = ANGULO_TILT * (velocity.x)
	input.x = mult_actual


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
# - 
func decidir_siguiente_ataque(__ = "?"):
	timer_espera.start( esperar_random() )
	yield( timer_espera, "timeout" )
	
	var eleccion = ATAQUES[randi() % ATAQUES.size()]
	
	match eleccion:
		"rayo":
			# Random rasho_lase1 o 2
			hacer_ataque("rasho_lase" + str(randi() % 2 + 1))





func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	hurtbox.desactivado = true










