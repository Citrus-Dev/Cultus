class_name Cultista
extends Personaje
 
export(NodePath) onready var arma = get_node(arma) as ControladorArmasNPC
export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

export(bool) var actor

var es_actor : bool setget set_es_actor

func set_es_actor(_actor : bool):
	if !is_inside_tree(): return # Pelotudo de mierda
	es_actor = _actor
	
	collision_layer = 0
	collision_mask = 0
	hurtbox.collision_mask = 0
	hitbox.collision_layer = 0
	
	ciego = actor
	if actor:
		set_collision_layer_bit(12, true)
		set_collision_mask_bit(11, true)
	else:
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(0, true)
		hitbox.set_collision_layer_bit(5, true)
		hurtbox.set_collision_mask_bit(4, true)


func _ready() -> void:
	hitbox = $Hitbox
	connect("objetivo_encontrado", self, "alertar")
	set_es_actor(actor)


func procesar_movimiento(_delta : float):
	var puede_moverse : bool = (
		!muerto and !disparando
	)
	
	if !puede_moverse: input = Vector2.ZERO
	
	movement_horizontal(_delta)
	velocity = move_and_slide_with_snap(velocity + knockback_procesable, snap, Vector2.UP, true)
	movement_vertical(_delta)
	
	knockback_procesable = Vector2.ZERO
	procesar_knockback()
	
	set_snap()


func alertar():
	if !ciego:
		fsm.transition_to("Perseguir")
		objetivo.connect("muerto", self, "perder_vista_jugador")


func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	
	# Si te ataca el jugador despertate (aunque este fuera del rango de deteccion)
	if objetivo is Personaje:
		objetivo = _dmg.atacante
		alertar()


func morir(_info : InfoDmg):
	emit_signal("muerto")
	muerto = true
	collision_mask = 1 # No colisionas con nada mas que el escenario
	hitbox.collision_layer = 0 # desactiva la hitbox totalmente
	hurtbox.collision_mask = 0 
	instanciar_ragdoll()
	fsm.transition_to("Muerte")
	cambiar_visibilidad(false)


func cambiar_visibilidad(_bool : bool):
	skin.visible = _bool
	arma.visible = _bool


func detectar_borde(_borde):
	emit_signal("borde_tocado", _borde)


func perder_vista_jugador():
	objetivo = null
	fsm.transition_to("Patrullar")

