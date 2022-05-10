# Toma la plataforma adyacente en una direccion e imita su estado (activo o inactivo)
# con un delay.
class_name PlataformaPropagacion
extends PlataformaAlterna

enum DIRS {
	NINGUNO,
	DERECHA,
	IZQUIERDA
}

export(float) var delay = 0.6
export(NodePath) var vecino_anterior_path 
export(DIRS) var direccion_busqueda_vecinos
export(float) var distancia_maxima_vecino

var timer_delay := Timer.new()
var vecino : PlataformaAlterna # Va a imitar el estado de esta plataforma

func _ready() -> void:
	if vecino_anterior_path:
		vecino = get_node(vecino_anterior_path)
		vecino.connect("cambiado", self, "imitar_cambio")
	
	timer_delay.one_shot = true
	timer_delay.wait_time = delay
	add_child(timer_delay)
	
	yield(get_tree(),"idle_frame")
	if direccion_busqueda_vecinos != 0:
		buscar_vecino()


func imitar_cambio(_bool : bool):
	timer_delay.start()
	yield(timer_delay, "timeout")
	alternar(_bool)


func buscar_vecino():
	var space_state = get_world_2d().direct_space_state
	var base_dir = Vector2.RIGHT if direccion_busqueda_vecinos == 1 else Vector2.LEFT
	var offset_y = Vector2(0, 4)
	
	var rc = space_state.intersect_ray(
		global_position + offset_y,
		(global_position + offset_y) + base_dir * distancia_maxima_vecino,
		[self],
		collision_mask
	)
	
	if rc.has("collider"):
		vecino = rc["collider"]
		vecino.connect("cambiado", self, "imitar_cambio")
