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
const DROP_VIDA = preload("res://main/Pickups/PickupHP.tscn")

func drop():
	# Chance de 1 en 4 de dropear vida, sino dropear balas
	var rng = randi() % 3
	if rng == 0:
		instanciar_pickup(DROP_VIDA)
	else:
		elegir_drop(tomar_lista_de_balas())


func elegir_drop(opciones : Dictionary):
	var final : Array
	
	for o in opciones:
		# La cantidad no va a ser el numero directo, va a ser un radio 
		# (porque 1 bala de railgun no vale menos que 2 bala de rifle)
		final.append(
			{
				"cant" : calcular_radio_de_balas(opciones[o]["cant"], opciones[o]["max"]),
				"id" : o
			}
		)
	
	final.sort_custom(self, "sort_custom_lista_balas")
	
	if final.empty(): return
	
	var id_elegido : String = final[0]["id"]
	convertir_id_a_escena(id_elegido)


func sort_custom_lista_balas(_a : Dictionary, _b : Dictionary):
	return _a["cant"] < _b["cant"]


func tomar_lista_de_balas() -> Dictionary:
	var inv = GameState.hack_tomar_inv_balas()
	return inv.tomar_balas_descubiertas()


func convertir_id_a_escena(id : String):
	match id:
		"Pistola":
			instanciar_pickup(DROP_PISTOLA)
		"Rifle":
			instanciar_pickup(DROP_RIFLE)
		"Escopeta":
			instanciar_pickup(DROP_ESCOPETA)
		"Granadas":
			instanciar_pickup(DROP_RIFLE_GRANADA)
		"Flechas":
			instanciar_pickup(DROP_BALLESTA)
		"Cohetes":
			instanciar_pickup(DROP_BAZUCA)


func instanciar_pickup(escena : PackedScene):
	var inst = escena.instance()
	get_parent().get_parent().add_child(inst)
	inst.global_position = get_parent().global_position


# Representa la cantidad de balas que tenes como un numero del 0 al 1
# Asi podemos comparar el procentaje de balas que te quedan de todos los tipos
func calcular_radio_de_balas(_cantidad : int, _max : int) -> float:
	return inverse_lerp(0, _max, _cantidad)

