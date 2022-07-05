class_name BossPaladin
extends Personaje

signal muerte_fachera_terminada

export(NodePath) onready var fsm = get_node(fsm) as StateMachine

# Vamos a poner nombres de movimientos aca. El sistema va a ir agarrando movimientos de aca hasta que
# no haya mas, y despues lo va a rellenar devuelta con empezar_ciclo
var ataques := []

var activo : bool

# Activa un ciclo de ataques
func empezar_boss():
	activo = true
	empezar_ciclo()


func empezar_ciclo():
	ataques = [
		"Caminar",
		"Caminar",
		"Saltar",
		"Saltar",
		"Saltar",
		"Giro",
		"Giro",
	]
	call_deferred("determinar_siguiente_ataque")


func determinar_siguiente_ataque():
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
	
	dir = sign(dir_a_jug.x)


func set_muerto(toggle : bool):
	muerto = toggle
	if toggle:
		collision_mask = 1 # No colisionas con nada mas que el escenario
		collision_layer = 0
		hitbox.collision_layer = 0 # desactiva la hitbox totalmente
		hitbox.set_deferred("monitorable", false)
		hitbox.collision_mask = 0 
	fsm.transition_to("Morir")
