class_name SkillEscudo
extends Node2D

const DURACION_PARRY := 0.6
const TIEMPO_COOLDOWN := 1.6
const VEL_DASH := 150.0

var jug : Jugador
var jug_hitbox : Hitbox
var area_escudo : Area2D
var timer_escudo : Timer
var timer_cooldown : Timer

var dir_mov : Vector2

func _ready():
	yield(get_parent(), "ready")
	jug = owner
	jug_hitbox = jug.hitbox
	area_escudo = get_child(0)
	area_escudo.connect("body_entered", self, "bloquear_bala")
	area_escudo.monitoring = false
	
	timer_escudo = Timer.new()
	add_child(timer_escudo)
	timer_escudo.one_shot = true
	timer_escudo.connect("timeout", self, "terminar")
	
	timer_cooldown = Timer.new()
	add_child(timer_cooldown)
	timer_cooldown.one_shot = true


func _draw():
	if !timer_escudo.is_stopped():
		var color = Color.blue if dir_mov == Vector2.ZERO else Color.lightblue
		color.a = 0.35
		draw_circle(area_escudo.position, 32.0, color)


func _process(delta):
	update()
	if puede_activar() and Input.is_action_just_pressed("escudo"):
		if jug.input.x == 0:
			empezar_block_quieto()
		else:
			empezar_dash(jug.input.x)


func _physics_process(delta):
	if !timer_escudo.is_stopped():
		jug.move_and_slide(dir_mov * VEL_DASH)


func puede_activar() -> bool:
	return bool(
		!jug.usando_habilidad and
		timer_cooldown.is_stopped()
	)


func activar():
	timer_escudo.start(DURACION_PARRY)
	timer_cooldown.start(TIEMPO_COOLDOWN)
	jug.stretcher.stretch(Vector2(1.2, 0.8), DURACION_PARRY)
	jug.movimiento_desactivado = true


func terminar():
	area_escudo.monitoring = false
	jug_hitbox.monitorable = true
	jug.movimiento_desactivado = false
	jug.velocity = Vector2.ZERO


func empezar_block_quieto():
	activar()
	dir_mov = Vector2.ZERO
	area_escudo.monitoring = true


func empezar_dash(dir_x : int):
	activar()
	dir_mov = Vector2(dir_x, 0)
	jug_hitbox.monitorable = false


func bloquear_bala(bala : ProyectilBase):
	var normal : Vector2 = Vector2.RIGHT.rotated(bala.velocity.angle())
	bala.velocity = bala.velocity.bounce(normal)
	bala.reflejar()


