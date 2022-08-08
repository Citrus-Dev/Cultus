# Que poronga es un shot??????
class_name Shot
extends Personaje

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

func _init():
	add_to_group("Enemigos")


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	var tipo = _info.dmg_tipo
	
#	if tipo == InfoDmg.DMG_TIPOS.EXPLOSION or tipo == InfoDmg.DMG_TIPOS.PLASMA:
#		instanciar_gibs()
#		emit_signal("muerto_gib")
#	else:
#		instanciar_ragdoll()


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		set_deferred("monitorable", false)
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
	cambiar_visibilidad(!toggle)
	fsm.transition_to("Muerte")
