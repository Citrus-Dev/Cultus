class_name Polilla
extends Personaje

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

func _init():
	add_to_group("Enemigos")


func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	input = Vector2.ZERO


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
	instanciar_ragdoll()
	cambiar_visibilidad(!toggle)


func on_parry(escudo : Node2D):
	var dir = (tomar_centro() - escudo.global_position).normalized() * 300
	var tiempo := 0.5
	
	fsm.transition_to("Stun", {"Tiempo" : tiempo, "Dir" : dir})
