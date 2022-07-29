class_name SkillEscudo
extends Node2D

const ESCENA_MEDIDOR_COOLDOWN = preload("res://main/UI/Hud/MedidorCooldown.tscn")
const TEXTURA_ICONO = preload("res://assets/ui/IconoHUDCruz.tres")

const DURACION_PARRY := 0.6
const DURACION_PARRY_DURO := 0.2
const TIEMPO_COOLDOWN := 1.6
const TIEMPO_COOLDOWN_DURO := 2.5
const VEL_DASH := 150.0

signal cooldown_update(valor)

var jug : Jugador
var jug_hitbox : Hitbox
var area_escudo : Area2D
var timer_escudo : Timer
var timer_cooldown : Timer

var dir_mov : Vector2
var desactivado : bool

func _ready():
	name = "skill_cruz"
	
	get_parent().connect("muerto", self, "set", ["desactivado", true])
	
	jug = get_parent()
	jug_hitbox = jug.hitbox
	area_escudo = get_child(0)
	area_escudo.connect("body_entered", self, "determinar_bloqueo")
	area_escudo.monitoring = false
	
	# Si esta el slide, borrarlo porque lo estamos reemplazando
	var slide = jug.get_node("skill_slide")
	if slide != null:
		slide.call_deferred("free")
	
	timer_escudo = Timer.new()
	add_child(timer_escudo)
	timer_escudo.one_shot = true
	timer_escudo.connect("timeout", self, "terminar")
	
	timer_cooldown = Timer.new()
	add_child(timer_cooldown)
	timer_cooldown.one_shot = true
	
	yield(get_tree(), "idle_frame")
	instanciar_medidor_cooldown()


func _draw():
	if !timer_escudo.is_stopped():
		var color = Color.blue if dir_mov == Vector2.ZERO else Color.lightblue
		color.a = 0.35
		draw_circle(area_escudo.position, 32.0, color)


func _process(delta):
	emit_signal("cooldown_update", timer_cooldown.time_left)
	update()
	if puede_activar() and Input.is_action_just_pressed("escudo"):
		if sign(jug.input.x) == 0:
			empezar_block_quieto()
		else:
			empezar_dash(jug.input.x)


func _physics_process(delta):
	if !timer_escudo.is_stopped():
		jug.move_and_slide(dir_mov * VEL_DASH)


func puede_activar() -> bool:
	return bool(
		!desactivado and
		!jug.usando_habilidad and
		timer_cooldown.is_stopped()
	)


func activar():
	jug.movimiento_desactivado = true
	jug_hitbox.monitorable = false


func terminar():
	area_escudo.monitoring = false
	jug_hitbox.monitorable = true
	jug.movimiento_desactivado = false
	jug.velocity = Vector2.ZERO


func empezar_block_quieto():
	timer_escudo.start(DURACION_PARRY_DURO)
	timer_cooldown.start(TIEMPO_COOLDOWN_DURO)
	jug.stretcher.stretch(Vector2(1.2, 0.8), DURACION_PARRY_DURO)
	
	activar()
	dir_mov = Vector2.ZERO
	area_escudo.monitoring = true


func empezar_dash(dir_x : int):
	timer_escudo.start(DURACION_PARRY)
	timer_cooldown.start(TIEMPO_COOLDOWN)
	jug.stretcher.stretch(Vector2(1.2, 0.8), DURACION_PARRY)
	
	activar()
	dir_x = sign(dir_x)
	dir_mov = Vector2(dir_x, 0)
	jug_hitbox.monitorable = false


func determinar_bloqueo(objeto_en_cuestion):
	if objeto_en_cuestion is ProyectilBase:
		bloquear_bala(objeto_en_cuestion)
	elif objeto_en_cuestion is Personaje:
		bloquear_individuo(objeto_en_cuestion)


func bloquear_individuo(individuo : Personaje):
	if individuo.has_method("on_parry"): individuo.call("on_parry", self)


func bloquear_bala(bala : ProyectilBase):
	var normal : Vector2 = Vector2.RIGHT.rotated(bala.velocity.angle())
	bala.velocity = bala.velocity.bounce(normal)
	bala.reflejar()


func instanciar_medidor_cooldown():
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	var inst = ESCENA_MEDIDOR_COOLDOWN.instance()
	hud.instanciar_medidor_cooldown(inst)
	inst.set_icono_textura(TEXTURA_ICONO)
	inst.set_color(Color.gold)
	inst.progress_bar.max_value = TIEMPO_COOLDOWN
	connect("cooldown_update", inst, "actualizar_valor")

