class_name Rueda
extends Personaje

const DIST_TEST := 23.0
const TEST_ARRIBA := 30.0
const GIBS = preload("res://main/Personajes/Rueda/GibsRueda.tscn")

export(NodePath) onready var anim_girar = get_node(anim_girar) as AnimationPlayer
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var rc1 = get_node(rc1) as RayCast2D
export(NodePath) onready var rc2 = get_node(rc2) as RayCast2D
export(NodePath) onready var fsm = get_node(fsm) as StateMachine

var girando: bool setget set_girando


func _init():
	add_to_group("Enemigos")


func _ready():
	connect("stun_terminado", self, "hack_terminar_stun")






func set_girando(toggle: bool):
	girando = toggle
	if girando:
		anim_girar.play("girar")
	else:
		anim_girar.play("girar_stop")


func detectar_borde(_borde):
	jump(randf() * jump_velocity)


func hack_terminar_stun():
	fsm.transition_to("Perseguir")


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		set_deferred("monitorable", false)
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
	cambiar_visibilidad(!toggle)
	
	var gibs = GIBS.instance()
	gibs.global_position = global_position
	get_parent().add_child(gibs)


func probar_pared() -> bool:
	var space = get_world_2d().direct_space_state
	var c1 = rc1.is_colliding()
	var c2 = rc2.is_colliding()
	return c1 or c2

