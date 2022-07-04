extends StaticBody2D

signal destruido

var segmentos := []
var segmento_velocidades := []
var segmentos_libres : bool

func _ready():
	for c in get_children():
		if "segmento" in c.name:
			segmentos.append(c)
			segmento_velocidades.append(Vector2.ZERO)


func _process(delta):
	if !segmentos_libres: return
	for seg in segmentos.size():
		segmentos[seg].global_position += segmento_velocidades[seg]
		segmento_velocidades[seg].y += delta * 10.0


func destruir():
	emit_signal("destruido")
	set_deferred("collision_layer", 0)
	segmentos_libres = true
	
	for i in segmentos.size():
		segmento_velocidades[i] = Vector2(
			rand_range(-0.1, 0.1),
			-0.5 - rand_range(-.5, .5)
		)
