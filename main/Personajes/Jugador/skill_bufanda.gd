class_name SkillBufanda
extends Node

const ESCENA_MEDIDOR_COOLDOWN = preload("res://main/UI/Hud/MedidorCooldown.tscn")
const TEXTURA_ICONO = preload("res://assets/ui/IconoHUDBufan.tres")
const SONIDO := preload("res://assets/sfx/player_grab.wav")

const TIEMPO_GANCHO := 0.05
const TIEMPO_GANCHO_AGARRADO := 0.6
const DISTANCIA := 230.0
const VEL_GANCHO := 350.0
const DIST_MINIMA := 25.0
const TIEMPO_COOLDOWN := 1.2
const TIEMPO_COOLDOWN_GANCHO := 0.7 # reducir a 0.2??

signal cooldown_update(valor)

var jug : Personaje
var bufan_sprite : BufanString
var timer_gancho : Timer
var timer_cooldown : Timer

var pos_objetivo : Vector2
var dir_gancho : Vector2
var attached : bool
var ultimo_objeto_agarrado: Node
var usando : bool

func _ready():
#	yield(get_parent(), "ready")
	jug = get_parent()
	bufan_sprite = jug.bufan
	
	timer_gancho = Timer.new()
	add_child(timer_gancho)
	timer_gancho.one_shot = true
	timer_gancho.connect("timeout", self, "terminar_gancho")
	
	timer_cooldown = Timer.new()
	add_child(timer_cooldown)
	timer_cooldown.one_shot = true
	
	yield(get_tree(), "idle_frame")
	instanciar_medidor_cooldown()


func _process(delta):
	emit_signal("cooldown_update", timer_cooldown.time_left)
	
	if !is_instance_valid(bufan_sprite):
		call_deferred("free")
		return
	

	if timer_cooldown.is_stopped() and Input.is_action_just_pressed("gancho"):
		Musica.hacer_sonido(SONIDO, jug.global_position, 1.6)
		pos_objetivo = jug.get_global_mouse_position()
		attached = true
		
		var agarre = encontrar_punto_de_agarre()
		if agarre != null: 
			pos_objetivo = agarre
			empezar_agarre()
			dir_gancho = (pos_objetivo - jug.global_position).normalized()
		else:
			pos_objetivo = limitar_distancia(pos_objetivo)
		
		timer_cooldown.start(TIEMPO_COOLDOWN_GANCHO if ultimo_objeto_agarrado is Hookpoint else TIEMPO_COOLDOWN)
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
		513 + 32768
	)
	
	if !rc.empty():
		ultimo_objeto_agarrado = rc["collider"].get_parent()
		print("ultimo_objeto_agarrado: " + ultimo_objeto_agarrado.name)

		if ultimo_objeto_agarrado is Hookpoint:
			var hp: Hookpoint = rc["collider"].get_parent()
			if !hp.activo:
				return null
			
			hp.usado()
			return hp.global_position

		elif ultimo_objeto_agarrado.has_meta("bloquear_gancho"):
			return

		else:
			return rc["position"]


func limitar_distancia(pos : Vector2):
	var dir : Vector2 = (pos - jug.global_position).normalized()
	var pos_final = jug.global_position + Vector2.RIGHT.rotated(dir.angle()) * DISTANCIA
	return pos_final


func instanciar_medidor_cooldown():
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	var inst = ESCENA_MEDIDOR_COOLDOWN.instance()
	hud.instanciar_medidor_cooldown(inst)
	inst.set_icono_textura(TEXTURA_ICONO)
	inst.set_color(Color.red)
	inst.progress_bar.max_value = TIEMPO_COOLDOWN
	connect("cooldown_update", inst, "actualizar_valor")







