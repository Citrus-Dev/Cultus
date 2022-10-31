class_name Caballero
extends Personaje

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var hurtbox_martillo = get_node(hurtbox_martillo) as Hurtbox

var gibs_escena

func _init():
	add_to_group("Enemigos")
	gibs_escena = preload("res://main/Personajes/Caballero/gibs/GibsCaballero.tscn")


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


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	var tipo = _info.dmg_tipo
	
	if tipo == InfoDmg.DMG_TIPOS.EXPLOSION or tipo == InfoDmg.DMG_TIPOS.PLASMA:
		instanciar_gibs()
		emit_signal("muerto_gib")
	else:
		instanciar_ragdoll()



# Llamado cuando recibis daño
func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	Musica.hacer_sonido(SND_HIT, global_position)
	
	if _dmg.atacante is Personaje:
		objetivo = _dmg.atacante
		objetivo.connect("muerto", self, "perder_vista_jugador")
		fsm.transition_to("Perseguir")
	
	alertar()



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


func instanciar_gibs():
	if gibs_escena == null:
		return
	var gib = gibs_escena.instance() as Gibs
	gib.global_position = global_position
	get_parent().add_child(gib)
	Musica.hacer_sonido(SND_GIB, global_position)



