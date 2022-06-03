class_name Jugador
extends Personaje

const CAMARA_FALSA = preload("res://main/Camaras/CamaraFalsa.tscn")
const CAMARA_REAL = preload("res://main/Camaras/CamaraReal.tscn")
const HUD = preload("res://main/UI/Hud/HUD.tscn")

export(NodePath) onready var stretcher = get_node(stretcher) as Stretcher
export(NodePath) onready var pos_bufanda = get_node(pos_bufanda) as Position2D
export(NodePath) onready var shaker = get_node(shaker) as Shaker
export(NodePath) onready var los = get_node(los) as LOSCheck

var controlador_armas 
var anim_level_trans : bool setget set_anim_level_trans
var usando_checkpoint : bool
var usando_habilidad : bool
var bufan
var objetos_pisando : Array # Los objetos sobre el que estas parado
var movimiento_desactivado : bool

# Va a mostrar un mensaje si no se encuentra nivel de checkpoint para respawnear
var debug_muerte_bugeada : bool

func _ready() -> void:
	los.connect("nuevo_objeto_en_los", self, "detectar_enemigo")
	
	crear_hud()
	crear_camaras()
	crear_bufanda()
	
	if !TransicionesDePantalla.inv_skills.empty():
		for skill in TransicionesDePantalla.inv_skills:
			agregar_skill(skill)


func _process(delta: float) -> void:
	if OS.is_debug_build() and debug_muerte_bugeada:
		DebugDraw.set_text("ERROR: No se encontró checkpoint guardado, no se puede respawnear.", "")
		DebugDraw.set_text("Reiniciar o cargar otro nivel.", "")


func _physics_process(delta):
	detectar_punto_seguro()


func procesar_movimiento(delta: float) -> void:
	var puede_moverse = puede_moverse()
	set_snap()
	if puede_moverse:
		sacar_input()
	
	movement_horizontal(delta)
	if !movimiento_desactivado:
		velocity = move_and_slide_with_snap(velocity + knockback, snap, Vector2.UP, true)
	
	if is_instance_valid(bufan):
		if input.x == 0.0 and is_on_floor():
			bufan.gravity = Vector2(0, 9.8)
		else:
			bufan.gravity = (-velocity.normalized()) * bufan.ropeLength
		
		if bufan.pos.size() > 0:
			bufan.set_start(pos_bufanda.global_position)
	
	movement_vertical(delta)
	
	borrar_objetos_pisando()
	if is_on_floor(): 
		tomar_objetos_pisando()
	
	if puede_moverse or puede_salto_en_largo(): input_jump()
	determinar_animacion()
	
	procesar_knockback()


func puede_moverse() -> bool:
	return (
		!muerto and
		!stun and
		!usando_habilidad and
		!usando_checkpoint and
		!anim_level_trans
	)


func puede_salto_en_largo() -> bool:
	return (
		!muerto and
		!stun and
		!usando_checkpoint and
		!anim_level_trans
	)


func determinar_animacion():
	if usando_habilidad:
		return
	
	if usando_checkpoint:
		return
	
	if !stun and !muerto and !turning:
		if input.x != 0.0:
			animador.play("walk")
		else:
			animador.play("idle")
		
		if not is_on_floor():
			if velocity.y <= 0:
				animador.play("jump")
			else:
				animador.play("fall")
	else:
		if stun and (animador.assigned_animation != "hurt" and animador.current_animation != "hurt_start"):
			animador.play("hurt_start")


func detectar_enemigo(_enemigo : Personaje):
	if _enemigo.objetivo == null:
		_enemigo.objetivo = self
		_enemigo.emit_signal("objetivo_encontrado")


func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(0.6)
	shaker.add_trauma(1.0)
	aplicar_stun()
	print("Jugador hit: " + str(_dmg.atacante))


func morir(_info : InfoDmg):
	emit_signal("muerto")
	muerto = true
	
	if is_instance_valid(bufan):
		bufan.call_deferred("free")
	collision_mask = 1 # No colisionas con nada mas que el escenario
	collision_layer = 0
	hitbox.collision_layer = 0 # desactiva la hitbox totalmente
	controlador_armas.activo = false
	instanciar_ragdoll()
	muerte_cambio_nivel()
	cambiar_visibilidad(false)


func muerte_cambio_nivel():
	var timer_muerte := Timer.new()
	timer_muerte.wait_time = 2.0
	add_child(timer_muerte)
	timer_muerte.start()
	
	yield(timer_muerte, "timeout")
	
	TransicionesDePantalla.muerte = true
	var err = get_tree().change_scene(TransicionesDePantalla.checkpoint_actual_escena)
	if err != OK: # Algo salio mal al cambiar el nivel
		debug_muerte_bugeada = true
		TransicionesDePantalla.muerte = false


func aplicar_stun():
	animador.play("hurt_start")
	alternar_stun(true)
	Congelar.congelar(self, 0.5)
	if !timer_stun.is_stopped():
		timer_stun.stop()
	
	friccion = 0.98
	procesar_knockback()
	
	# Si el enemigo esta en el aire y no es un enemigo volador le damos mas tiempo
	# de stun (porque lo estas tirando a la mierda y queda medio duro si se recupera
	# en el aire)
	timer_stun.start(tiempo_stun)
	yield(timer_stun, "timeout")
	
	valor_default("friccion")
	alternar_stun(false)


func alternar_stun(_bool : bool):
	stun = _bool
	if controlador_armas:
		controlador_armas.set_process(!_bool)
		controlador_armas.set_physics_process(!_bool)


func alternar_checkpoint(_bool : bool):
	no_gravedad = _bool
	if _bool:
		input = Vector2.ZERO
		velocity.y = 0
		controlador_armas.set_activo(false)
		usando_checkpoint = _bool
		animador.play("mirar")
	else:
		animador.play("dejar_de_mirar")
		yield(animador, "animation_finished")
		controlador_armas.set_activo(true)
		usando_checkpoint = _bool


func set_dir(_dir : int):
	if !puede_moverse() or _dir == 0: return
	
	if _dir != dir:
		turning = true
		animador.play("turn")
	
	dir = _dir
	if _dir != 0: 
		skin.scale.x = _dir


func set_anim_level_trans(_bool : bool):
	if _bool:
		set_dir(sign(input.x))
	anim_level_trans = _bool
	controlador_armas.activo = !_bool


func sacar_input():
	input = Input.get_vector(
		"mov_izq", "mov_der",
		"mov_arr", "mov_abaj"
	).normalized()
	
#	if input.x != 0.0:
#		set_dir(sign(input.x))


# Detecta el input si tenes que saltar.
# Tambien cancela el salto si estas en el aire y soltas la tecla.
func input_jump():
	if is_on_floor() or Comandos.noclip:
		if Input.is_action_just_pressed("mov_arr"):
			jump()
			stretcher.stretch(Vector2(0.8, 1.2), 1.0)
	elif velocity.y < 0.0:
		if Input.is_action_just_released("mov_arr"):
			velocity.y *= 0.5


func borrar_objetos_pisando():
	for i in objetos_pisando:
		if i is PlataformaFragil:
			i.pisando = false
	objetos_pisando.clear()


func tomar_objetos_pisando():
	var x_offset := 6
	var pos_mas_offset := Vector2(global_position.x + x_offset, global_position.y)
	var pos_menos_offset := Vector2(global_position.x - x_offset, global_position.y)
	
	var space_state = get_world_2d().direct_space_state
	var rc1 = space_state.intersect_ray(
		pos_mas_offset,
		pos_mas_offset + Vector2.DOWN * 2,
		[self],
		collision_mask
	)
	var rc2 = space_state.intersect_ray(
		pos_menos_offset,
		pos_mas_offset + Vector2.DOWN * 2,
		[self],
		collision_mask
	)
	
	if !rc1.empty() and !objetos_pisando.has(rc1["collider"]): 
		objetos_pisando.append(rc1["collider"])
	if !rc2.empty() and !objetos_pisando.has(rc2["collider"]): 
		objetos_pisando.append(rc2["collider"])
	
	for i in objetos_pisando:
		if i is PlataformaFragil:
			i.pisando = true


func salto_largo(_jump_vel = jump_velocity):
	is_jumping = true
	snap = Vector2.ZERO
	velocity.y = _jump_vel
	velocity.x *= 2000


func crear_camaras():
	var cam_falsa = CAMARA_FALSA.instance()
	var cam_real = CAMARA_REAL.instance()
	
	add_child(cam_falsa)
	get_parent().call_deferred("add_child", cam_real)
	cam_real.current = true
	cam_real.camara_falsa = cam_falsa


func crear_bufanda():
	var bufan_inst = (load("res://main/libs/Verlet/Verlet.tscn")).instance()
	get_parent().call_deferred("add_child", bufan_inst)
	bufan = bufan_inst
	bufan.global_position = global_position


func crear_hud():
	if is_instance_valid(ControladorUi.hud):
		printerr("ERROR: jugador intento crear HUD cuando ya existe.")
		ControladorUi.hud.free()
	var hud = HUD.instance()
	ControladorUi.hud = hud
	ControladorUi.jugador = self
	get_tree().get_root().call_deferred("add_child", hud)


func detectar_punto_seguro():
	if bool(
		is_on_floor()
	):
		TransicionesDePantalla.ultimo_punto_seguro = global_position


func agregar_skill(skill_id : String):
	var armas := Armas.new()
	var skill = load(armas.skills_lista[skill_id])
	var inst = skill.instance()
	add_child(inst)
	
	if !TransicionesDePantalla.inv_skills.has(skill_id):
		TransicionesDePantalla.inv_skills[skill_id] = true


func osciliar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x
