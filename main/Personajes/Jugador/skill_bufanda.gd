class_name SkillBufanda
extends Node

const TIEMPO_GANCHO := 0.05
const TIEMPO_GANCHO_AGARRADO := 0.6
const DISTANCIA := 230.0
const VEL_GANCHO := 350.0
const DIST_MINIMA := 25.0
const TIEMPO_COOLDOWN := 1.2

var jug : Jugador
var bufan_sprite : BufanString
var timer_gancho : Timer
var timer_cooldown : Timer

var pos_objetivo : Vector2
var dir_gancho : Vector2
var attached : bool
var usando : bool

func _ready():
	yield(get_parent(), "ready")
	jug = owner
	bufan_sprite = jug.bufan
	
	timer_gancho = Timer.new()
	add_child(timer_gancho)
	timer_gancho.one_shot = true
	timer_gancho.connect("timeout", self, "terminar_gancho")
	
	timer_cooldown = Timer.new()
	add_child(timer_cooldown)
	timer_cooldown.one_shot = true


func _process(delta):
	if !is_instance_valid(bufan_sprite):
		call_deferred("free")
		return
	
	if timer_cooldown.is_stopped() and Input.is_action_just_pressed("gancho"):
		pos_objetivo = jug.get_global_mouse_position()
		attached = true
		
		var agarre = encontrar_punto_de_agarre()
		if agarre != null: 
			pos_objetivo = agarre
			empezar_agarre()
			dir_gancho = (pos_objetivo - jug.global_position).normalized()
		else:
			pos_objetivo = limitar_distancia(pos_objetivo)
		
		timer_cooldown.start(TIEMPO_COOLDOWN)
		timer_gancho.start(TIEMPO_GANCHO if agarre == null else TIEMPO_GANCHO_AGARRADO)
	
	if attached:
		bufan_sprite.pos[bufan_sprite.pos.size() - 1] = pos_objetivo
	
	if detectar_cercania(): terminar_gancho()


func _physics_process(delta):
	if usando:
		jug.move_and_slide(dir_gancho * VEL_GANCHO)


func terminar_gancho():
	attached = false
	if !timer_gancho.is_stopped():
		timer_gancho.stop()
	if usando:
		jug.usando_habilidad = false
		jug.movimiento_desactivado = false
		jug.velocity = dir_gancho * VEL_GANCHO
		usando = false


func empezar_agarre():
	jug.usando_habilidad = true
	jug.movimiento_desactivado = true
	usando = true


func detectar_cercania() -> bool:
	return abs((jug.global_position - pos_objetivo).length()) < DIST_MINIMA


func encontrar_punto_de_agarre():
	var space = jug.get_world_2d().direct_space_state
	var rc = space.intersect_ray(
		jug.global_position,
		limitar_distancia(pos_objetivo),
		[],
		1
	)
	
	if !rc.empty():
		return rc["position"]


func limitar_distancia(pos : Vector2):
	var dir : Vector2 = (pos - jug.global_position).normalized()
	var pos_final = jug.global_position + Vector2.RIGHT.rotated(dir.angle()) * DISTANCIA
	return pos_final










