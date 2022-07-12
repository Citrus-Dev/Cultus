# Recibe señales cuando muere un enemigo y decide que dropear
# Tomar una lista de todos los tipos de balas que descubrio el jugador (osea de armas que si tiene)
# Dropear del que tenga menos
class_name DropManager
extends Node

const DROP_PISTOLA = preload("res://main/Pickups/PickupBalasRevolver.tscn")
const DROP_ESCOPETA = preload("res://main/Pickups/PickupBalasEscopeta.tscn")
const DROP_BALLESTA = preload("res://main/Pickups/PickupBalasBallesta.tscn")
const DROP_RIFLE = preload("res://main/Pickups/PickupBalasAR.tscn")
const DROP_RIFLE_GRANADA = preload("res://main/Pickups/PickupGranadas.tscn")
const DROP_BAZUCA = preload("res://main/Pickups/PickupGauss.tscn")

func drop():
	elegir_drop(tomar_lista_de_balas())


func elegir_drop(opciones : Dictionary):
	var final : Array
	for o in opciones:
		final.append(
			{
				"cant" : opciones[o]["cant"],
				"id" : o
			}
		)
	breakpoint
	





func tomar_lista_de_balas() -> Dictionary:
	var inv = GameState.hack_tomar_inv_balas()
	return inv.tomar_balas_descubiertas()


func convertir_id_a_escena(id : String):
	match id:
		"PISTOLA":
			instanciar_pickup(DROP_PISTOLA)
		"RIFLE":
			instanciar_pickup(DROP_RIFLE)
			instanciar_pickup(DROP_RIFLE_GRANADA)
		"ESCOPETA":
			instanciar_pickup(DROP_ESCOPETA)
		"BALLESTA":
			instanciar_pickup(DROP_BALLESTA)
		"BAZUCA":
			instanciar_pickup(DROP_BAZUCA)


func instanciar_pickup(escena : PackedScene):
	var inst = escena.instance()
	get_parent().get_parent().add_child(inst)
	inst.global_position = get_parent().global_position

