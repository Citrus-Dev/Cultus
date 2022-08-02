class_name Rueda
extends Personaje

export(NodePath) onready var anim_girar = get_node(anim_girar) as AnimationPlayer
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

var girando: bool setget set_girando

func set_girando(toggle: bool):
	girando = toggle
	if girando:
		anim_girar.play("girar")
	else:
		anim_girar.play("girar_stop")


func detectar_borde(_borde):
	jump(randf() * jump_velocity)


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
