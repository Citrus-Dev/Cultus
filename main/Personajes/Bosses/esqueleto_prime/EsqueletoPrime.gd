class_name EsqueletoPrime
extends Personaje

const VEL_AJUSTE_MANO := 2.0
const VEL_AJUSTE_MANO_GOLPE := 15.0

signal activo

export(NodePath) onready var target_mano_1 = get_node(target_mano_1) as Position2D
export(NodePath) onready var target_mano_2 = get_node(target_mano_2) as Position2D
export(NodePath) onready var mano_1 = get_node(mano_1) as Node2D
export(NodePath) onready var mano_2 = get_node(mano_2) as Node2D
export(Array, NodePath) var shaker_paths
export(Array, NodePath) var hurtbox_paths

export(bool) var atacando: bool
export(bool) var muriendo: bool

# Vamos a poner nombres de movimientos aca. El sistema va a ir agarrando movimientos de aca hasta que
# no haya mas, y despues lo va a rellenar devuelta con empezar_ciclo
var ataques := []
var activo : bool
var counter_idle: int
var shakers := []
var hurtboxes := []

func _ready():
	add_to_group("Enemigos")
	add_to_group("Boss")
	mano_1.global_position = target_mano_1.global_position
	mano_2.global_position = target_mano_2.global_position
	animador.connect("animation_finished", self, "animador_trigger")
	
	for i in shaker_paths:
		shakers.append(get_node(i))
	for i in hurtboxes:
		hurtboxes.append(get_node(i))


func _process(delta):
	var vel : float = (VEL_AJUSTE_MANO_GOLPE if atacando else VEL_AJUSTE_MANO) * delta
	mano_1.global_position = lerp(mano_1.global_position, target_mano_1.global_position, vel)
	mano_1.rotation = lerp_angle(mano_1.rotation, target_mano_1.rotation, vel)
	mano_2.global_position = lerp(mano_2.global_position, target_mano_2.global_position, vel)
	mano_2.rotation = lerp_angle(mano_2.rotation, target_mano_2.rotation, vel)
	
	if muriendo:
		for i in shakers:
			i.add_trauma(5)


# Activa un ciclo de ataques
func empezar_boss():
	activo = true
	emit_signal("activo")
	empezar_ciclo()


func animador_trigger(anim: String):
	if anim == "idle":
		bajar_counter_idle()
	
	if anim != "emerger" and counter_idle <= 0:
		determinar_siguiente_ataque()
		reset_counter_idle()
	
	if counter_idle > 0:
		animador.play("idle")


func empezar_ciclo():
	if !activo: return
	
	ataques = [
		"golpe1",
		"golpe_mucho"
	]
	call_deferred("determinar_siguiente_ataque")


func determinar_siguiente_ataque():
#	if !fase2 and status.hp < status.hp_max / 2:
#		empezar_fase_2()
#		return
	
	if !ataques.empty():
		var sig_atq_index : int = randi() % ataques.size()
		var sig_ataque : String = ataques[sig_atq_index]
		ataques.remove(sig_atq_index)
		
		animador.play(sig_ataque)
	else:
		empezar_ciclo()


func reset_counter_idle():
	counter_idle = randi() % 3 + 1


func bajar_counter_idle():
	counter_idle -= 1


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	remove_from_group("Boss")


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		for hurtbox in hurtboxes:
			hurtbox.collision_layer = 0 # desactiva la hitbox totalmente
			hurtbox.set_deferred("monitorable", false)
			hurtbox.set_deferred("monitoring", false)
			hurtbox.collision_mask = 0 
	
	animador.play("muerte")
	activo = false


func borrar():
	call_deferred("free")


func golpe_mano1():
	golpe(mano_1.global_position)


func golpe_mano2():
	golpe(mano_2.global_position)


func golpe(pos: Vector2):
	pass


