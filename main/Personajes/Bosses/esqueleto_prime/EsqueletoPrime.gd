class_name EsqueletoPrime
extends Personaje

const VEL_AJUSTE_MANO := 2.0
const VEL_AJUSTE_MANO_GOLPE := 15.0
const BALA_ESCENA := preload("res://main/Proyectiles/ProyCultista.tscn")
const PIEDRA_ESCENA := preload("res://main/Proyectiles/PiedraBoss.tscn")

signal activo

export(NodePath) onready var target_mano_1 = get_node(target_mano_1) as Position2D
export(NodePath) onready var target_mano_2 = get_node(target_mano_2) as Position2D
export(NodePath) onready var mano_1 = get_node(mano_1) as Node2D
export(NodePath) onready var mano_2 = get_node(mano_2) as Node2D
export(NodePath) onready var punto_de_disparo = get_node(punto_de_disparo  ) as Node2D
export(Array, NodePath) var shaker_paths
export(Array, NodePath) var hurtbox_paths
export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(int) var dmg_rayos

export(bool) var atacando: bool
export(bool) var muriendo: bool
export(bool) var mirando: bool

var jugref: Personaje
var jugador_en_lugar_de_mierda: bool

# Vamos a poner nombres de movimientos aca. El sistema va a ir agarrando movimientos de aca hasta que
# no haya mas, y despues lo va a rellenar devuelta con empezar_ciclo
var ataques := []
var activo : bool
var counter_idle: int
var shakers := []
var hurtboxes := []

var bala_dmg: InfoDmg

func _ready():
	set_process(false)
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
	
	if mirando:
		mirar(delta)


# Activa un ciclo de ataques
func empezar_boss():
	activo = true
	emit_signal("activo")
	jugref = get_tree().get_nodes_in_group("Jugador")[0]
	empezar_ciclo()
	set_process(true)
	barra_hp.setup()


func animador_trigger(anim: String):
	if jugador_en_lugar_de_mierda:
		animador.play("golpe_no_estes_ahi")
		return
	
	if anim == "idle":
		bajar_counter_idle()
	
	if anim != "emerger" and counter_idle <= 0:
		determinar_siguiente_ataque()
		reset_counter_idle()
		return
	
	if counter_idle > 0:
		animador.play("idle")
		return


func empezar_ciclo():
	if !activo: return
	
	ataques = [
		"golpe1",
		"golpe1",
		"golpe1",
		"rayos1",
		"rayos1",
	]
	call_deferred("determinar_siguiente_ataque")


func determinar_siguiente_ataque():
	if !ataques.empty():
		var sig_atq_index : int = randi() % ataques.size()
		var sig_ataque : String = ataques[sig_atq_index]
		ataques.remove(sig_atq_index)
		
		animador.play(sig_ataque)
	else:
		empezar_ciclo()


func reset_counter_idle():
	counter_idle = randi() % 2 + 1


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
	barra_hp.borrar_barra()
	activo = false


func borrar():
	call_deferred("free")


func golpe_mano1():
	golpe(mano_1.global_position)


func golpe_mano2():
	golpe(mano_2.global_position)


func golpe(pos: Vector2):
	var offset := (Vector2(20, 32))
	var efecto := EfectoCirculo.new(
		Color.whitesmoke,
		0.0,
		64.0,
		0.35
	)
	get_tree().root.add_child(efecto)
	efecto.global_position = pos + offset
	
	var vel_x := 25.0
	var vel_y := -75.0
	spawnear_piedra(pos, offset + Vector2(vel_x, vel_y * randf()))
	spawnear_piedra(pos, offset + Vector2(-vel_x, vel_y + randf()))


func mirar(delta: float):
	var dir: Vector2 = jugref.global_position - skin.global_position
	skin.rotation = lerp_angle(skin.rotation, dir.angle(), delta)


func disparar():
	# Entre 6 y 8 disparos
#	var disparos = randi() % 8 + 6
	var disparos = 8
	
	for i in disparos:
		yield(get_tree().create_timer(0.2), "timeout")
		crear_bala(punto_de_disparo.global_position, skin.rotation)


func crear_bala(pos: Vector2, rot: float):
	if bala_dmg == null:
		bala_dmg = InfoDmg.new()
		bala_dmg.dmg_cantidad = dmg_rayos
	
	var proy: ProyectilBase = BALA_ESCENA.instance()
	proy.global_position = pos
	proy.rotation = rot + rand_range(-0.2, 0.2)
	proy.info_dmg = bala_dmg
	proy.move_speed = 350
	
	get_tree().root.add_child(proy)


func set_jugador_en_lugar_de_mierda(__, valor: bool):
	jugador_en_lugar_de_mierda = valor
	if animador.current_animation == "idle":
		animador_trigger("idle")


func spawnear_piedra(pos: Vector2, dir: Vector2):
	var inst = PIEDRA_ESCENA.instance() as PiedraBoss
	inst.velocity = dir
	inst.velocidad_rotacion = 0.2 * sign(velocity.x)
	get_tree().root.add_child(inst)
	inst.global_position = pos

