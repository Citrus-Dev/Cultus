class_name Polilla
extends Personaje

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

var gibs_escena

func _init():
	add_to_group("Enemigos")
	gibs_escena = preload("res://main/Personajes/Polilla/gibs/GibsPolilla.tscn")


func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	input = Vector2.ZERO


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
	instanciar_ragdoll()
	cambiar_visibilidad(!toggle)


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	instanciar_gibs()


func on_parry(escudo : Node2D):
	var dir = (tomar_centro() - escudo.global_position).normalized() * 300
	var tiempo := 0.5
	
	fsm.transition_to("Stun", {"Tiempo" : tiempo, "Dir" : dir})


func instanciar_gibs():
	if gibs_escena == null:
		return
	var gib = gibs_escena.instance() as Gibs
	gib.global_position = global_position
	get_parent().add_child(gib)


# Llamado cuando recibis daño
func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	Musica.hacer_sonido(SND_HIT, global_position)
	
	if _dmg.atacante is Personaje:
		objetivo = _dmg.atacante
		objetivo.connect("muerto", self, "perder_vista_jugador")
		fsm.transition_to("Perseguir")
	
	alertar()


func alertar():
	if !ciego and !muerto:
		add_to_group("EnemigosAlertados")
		
