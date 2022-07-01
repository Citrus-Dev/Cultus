class_name Caballero
extends Personaje

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var hurtbox_martillo = get_node(hurtbox_martillo) as Hurtbox

func _init():
	add_to_group("Enemigos")


func _ready() -> void:
	max_velocidad_horizontal += rand_range(-25, 25)
	hitbox = $Hitbox
	connect("objetivo_encontrado", self, "alertar")


func alertar():
	if !ciego and !muerto:
		fsm.transition_to("Perseguir")
		objetivo.connect("muerto", self, "perder_vista_jugador")
		add_to_group("EnemigosAlertados")


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
		hurtbox_martillo.collision_mask = 0 
	cambiar_visibilidad(!toggle)
	fsm.transition_to("Morir")


func cambiar_visibilidad(_bool : bool):
	skin.visible = _bool


func detectar_borde(_borde):
	emit_signal("borde_tocado", _borde)


func perder_vista_jugador():
	objetivo = null
	fsm.transition_to("Idle")


func on_parry(escudo : Node2D):
	var dir = (tomar_centro() - escudo.global_position).normalized() * 500
	var tiempo := 0.5
	
	fsm.transition_to("Stun", {"Tiempo" : tiempo, "Dir" : dir})
