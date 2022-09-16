# Que poronga es un shot??????
class_name Shot
extends Personaje

const PROYECTILES = preload("res://main/Proyectiles/ProyectilHomingMejor.tscn")

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var trigger_block = get_node(trigger_block) as Area2D
export(NodePath) onready var sprite_circ = get_node(sprite_circ) as Sprite

func esta_bloqueado() -> bool:
	return trigger_block.get_overlapping_bodies().size() > 0


func _init():
	add_to_group("Enemigos")


func evento_dmg(_dmg : InfoDmg):
	efecto_brillo_dmg(.6)
	
	# Si te ataca el jugador despertate (aunque este fuera del rango de deteccion)
	if _dmg.atacante is Personaje:
		objetivo = _dmg.atacante
		alertar()


func detectar_borde(_borde):
	emit_signal("borde_tocado", _borde)


func alertar():
	if !ciego and !muerto:
		fsm.transition_to("Ataque")
		objetivo.connect("muerto", self, "perder_vista_jugador")
		add_to_group("EnemigosAlertados")


func morir(_info : InfoDmg):
	if muerto: return
	emit_signal("muerto")
	set_muerto(true)
	remove_from_group("EnemigosAlertados")
	remove_from_group("Enemigos")
	
	var tipo = _info.dmg_tipo


func mirar_al_jugador():
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	var dir_a_jug = jug.global_position - global_position
	
	set_dir(sign(dir_a_jug.x))


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


func hacer_proyectiles():
	var cantidad := 3
	var proys := []
	
	var dmg = InfoDmg.new()
	dmg.dmg_cantidad = 30
	dmg.dmg_tipo = InfoDmg.DMG_TIPOS.EXPLOSION
	
	for i in cantidad:
		proys.append(PROYECTILES.instance())
		proys[i].global_position.y -= 48.0
		proys[i].target = objetivo
		proys[i].info_dmg = dmg
		add_child(proys[i])
	
	proys[1].global_position.x -= 16
	proys[1].global_position.y -= 16
	proys[2].global_position.x += 16
	proys[2].global_position.y -= 16

