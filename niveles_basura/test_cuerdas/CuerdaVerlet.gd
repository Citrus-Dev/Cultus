class_name CuerdaVerlet
extends Node2D

export(float) var largo_de_segmento # D
export(int) var cantidad_de_segmentos # C
export(Vector2) var gravedad # G
export(int) var iteraciones # I

var lista_puntos : Dictionary

var rend_linea : Line2D

func _ready() -> void:
	rend_linea = get_node("Line2D")
	rend_linea.points.resize(0)
	
	for s in cantidad_de_segmentos:
		var altura_segmento_anterior : float
		if lista_puntos.size() == 0:
			altura_segmento_anterior = 0
		else:
			altura_segmento_anterior = lista_puntos[max(s - 1, 0)]["pos_actual"].y + largo_de_segmento
		
		var pos_punto = Vector2(0, altura_segmento_anterior)
		lista_puntos[s] = {
				"pos_actual" : pos_punto,
				"pos_vieja" : pos_punto}


func _physics_process(delta: float) -> void:
	simular(delta)
	for i in iteraciones:
		limitar()
	update()
	
	global_position.x += 10 * delta


func _draw() -> void:
	for i in lista_puntos:
		draw_circle(lista_puntos[i]["pos_actual"], 1, Color.yellow)
	renderizar_cuerda()


# Devuelve la posiciond el mouse en relacion a la base de la cuerda
func tomar_posicion_del_mouse() -> Vector2:
	var pos = get_viewport().get_mouse_position()
	return pos - global_position


func agarrar_array_de_vectores_pos_actual() -> PoolVector2Array:
	var arr : PoolVector2Array
	for i in lista_puntos:
		arr.append(lista_puntos[i]["pos_actual"])
	return arr


func renderizar_cuerda():
	rend_linea.points = agarrar_array_de_vectores_pos_actual()


func simular(_delta : float):
	for i in lista_puntos:
		var punto = lista_puntos[i]
		var velocidad = punto["pos_actual"] - punto["pos_vieja"]
		punto["pos_vieja"] = punto["pos_actual"]
		punto["pos_actual"] += velocidad * _delta
		punto["pos_actual"] += gravedad


func limitar():
	var primer_seg = lista_puntos[0]
#	primer_seg["pos_actual"] = tomar_posicion_del_mouse()
	primer_seg["pos_actual"] = Vector2.ZERO
	
	for i in lista_puntos.size() - 1:
		
		var seg = lista_puntos[i]
		var seg_siguiente = lista_puntos[i + 1]
		
		var distancia = (seg["pos_actual"] - seg_siguiente["pos_actual"]).length()
		var error = abs(distancia - largo_de_segmento)
		
		var cambio_dir : Vector2
		if distancia > largo_de_segmento:
			cambio_dir = (seg["pos_actual"] - seg_siguiente["pos_actual"]).normalized()
		elif distancia < largo_de_segmento:
			cambio_dir = (seg_siguiente["pos_actual"] - seg["pos_actual"]).normalized()
		
		var cambio_fuerza : Vector2 = cambio_dir * error
		
		if i != 0:
			seg["pos_actual"] -= cambio_fuerza * error
			seg_siguiente["pos_actual"] += cambio_fuerza * 0.5
		else:
			seg_siguiente["pos_actual"] += cambio_fuerza
#
#		if is_nan(seg["pos_actual"].x):
#			breakpoint
