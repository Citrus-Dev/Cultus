class_name Esqueleto
extends Cultista

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


func morir(_info : InfoDmg):
	emit_signal("muerto")
	if _info.atacante:
		aplicar_knockback(350, (global_position - _info.atacante.global_position))
	aplicar_stun()
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hurtbox.collision_mask = 0 
#	cambiar_visibilidad(!toggle)
	fsm.transition_to("Muerte")


func instanciar_gibs():
	if gibs_escena == null:
		return
	var gib = ragdoll_escena.instance() as Gibs
	gib.global_position = global_position
	get_parent().add_child(gib)


