# Busca contexto para el steering, es decir, determina el vector de interes buscando
# obstaculos alrededor del user.
class_name Steering
extends Node

export(float) var distancia_de_deteccion
export(int) var num_rayos = 8

var user : Personaje
var debug_drawer = DebugCanvasDrawer.new(self)

var rayos := []			# Todos los rayos.
var interes := []		# Direcciones hacia donde queremos ir.
var peligro := []		# Direcciones hacia donde NO queremos ir.

var dir_final : Vector2
var dir_avoid : Vector2

func _ready() -> void:
#	add_child(debug_drawer)
	user = owner
	
	rayos.resize(num_rayos)
	interes.resize(num_rayos)
	peligro.resize(num_rayos)
	# Hacemos que las direcciones en "rayos" hagan un círculo alrededor del user.
	for i in num_rayos:
		var angulo = i * 2 * PI / num_rayos
		rayos[i] = Vector2.RIGHT.rotated(angulo)


func tomar_velocidad(direccion : Vector2) -> Vector2:
	set_interes(direccion)
	set_peligro()
	set_dir_avoid()
	set_dir_final()
	
#	if Comandos.debug_steer: debug_drawer.update()
	
	user.velocity -= dir_avoid * 5
	return dir_final


func set_interes(direccion : Vector2):
	if direccion != Vector2.ZERO:
		var dir_objetivo = direccion
		for i in num_rayos:
			var d = rayos[i].dot(dir_objetivo)
			interes[i] = max(0, d)
	else:
		for i in num_rayos:
			var d = rayos[i].dot(user.transform.x)
			interes[i] = max(0, d)


func set_peligro():
	var space_state = user.get_world_2d().direct_space_state
	for i in num_rayos:
		var rc = space_state.intersect_ray(
				user.global_position,
				user.global_position + rayos[i] * distancia_de_deteccion,
				[user, self],
				user.collision_mask
		)
		
		peligro[i] = 1.0 if rc else 0.0


func set_dir_avoid():
	dir_avoid = Vector2.ZERO
	for i in num_rayos:
		dir_avoid += rayos[i] if peligro[i] > 0 else Vector2.ZERO
	dir_avoid = dir_avoid.normalized()


func set_dir_final():
	# Borrar insteres en slots que tienen peligro
	for i in num_rayos:
		if peligro[i] > 0.0:
			interes[i] = 0.0
	
	# Elegir direccion basado en el interes.
	dir_final = Vector2.ZERO
	for i in num_rayos:
		dir_final += rayos[i] * interes[i]
#	dir_final = (dir_final -  dir_avoid).normalized()
	dir_final = dir_final.normalized()

