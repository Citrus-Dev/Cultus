class_name BossPaladin
extends Personaje

signal muerte_fachera_terminada

export(NodePath) onready var fsm = get_node(fsm) as StateMachine
export(NodePath) onready var hurtbox_contacto = get_node(hurtbox_contacto) as Hurtbox
export(NodePath) onready var hurtbox_pignia = get_node(hurtbox_pignia) as Hurtbox
export(NodePath) onready var hurtbox_giro = get_node(hurtbox_giro) as Hurtbox
export(Color) var color_fase2

# Vamos a poner nombres de movimientos aca. El sistema va a ir agarrando movimientos de aca hasta que
# no haya mas, y despues lo va a rellenar devuelta con empezar_ciclo
var ataques := []

var activo : bool
var fase2 : bool

var tween : Tween

func _ready():
	tween = Tween.new()
	add_child(tween)
	
	connect("objetivo_encontrado", self, "alertar")
	add_to_group("Enemigos")
	add_to_group("Boss")


# Activa un ciclo de ataques
func empezar_boss():
	activo = true
	empezar_ciclo()
	mirar_al_jugador()


func procesar_movimiento(_delta : float):
	set_snap()
	
	movement_horizontal(_delta)
	velocity = move_and_slide_with_snap(velocity + knockback_procesable, snap, Vector2.UP, true)
	movement_vertical(_delta)


func set_dir(_dir : int):
	if _dir != 0: 
		dir = _dir
		skin.scale.x = _dir


func empezar_ciclo():
	ataques = [
		"Caminar",
		"Caminar",
		"Saltar",
		"Saltar",
		"Saltar",
		"Piña",
		"Piña",
		"Giro",
		"Giro",
	]
	call_deferred("determinar_siguiente_ataque")


func determinar_siguiente_ataque():
	if !fase2 and status.hp < status.hp_max / 2:
		empezar_fase_2()
		return
	
	if !ataques.empty():
		var sig_atq_index : int = randi() % ataques.size()
		var sig_ataque : String = ataques[sig_atq_index]
		ataques.remove(sig_atq_index)
		
		fsm.transition_to(sig_ataque)
	else:
		empezar_ciclo()


func mirar_al_jugador():
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	var dir_a_jug = jug.global_position - global_position
	
	set_dir(sign(dir_a_jug.x))


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hitbox.set_deferred("monitorable", false)
		hitbox.collision_mask = 0 
	fsm.transition_to("Morir")


func set_animacion(anim : String):
	var animanterior := animador.current_animation
	animador.stop()
	animador.play(anim)
	animador.advance(0)
	yield(get_tree(), "idle_frame")
	if animador.current_animation != anim: 
		printerr("QUE CARAJO: " + anim + ", anim anterior: " + animanterior)


func alertar():
	if !muerto:
		objetivo.connect("muerto", self, "perder_vista_jugador")
		add_to_group("EnemigosAlertados")


func empezar_fase_2():
	fase2 = true
	fsm.transition_to("TransFase2")


func fase2_cambiar_color():
	tween.interpolate_property(
		self,
		"modulate",
		modulate,
		color_fase2,
		1.0,
		Tween.TRANS_LINEAR
	)
	tween.start()


func fase2_revertir_color():
	if !fase2: return
	tween.interpolate_property(
		self,
		"modulate",
		modulate,
		Color.white,
		0.6,
		Tween.TRANS_LINEAR
	)
	tween.start()

