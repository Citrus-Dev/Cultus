class_name CuerdaVerletV2
extends Node2D

export(float) var largo_de_segmento # D
export(int) var cantidad_de_segmentos # C
export(Vector2) var gravedad # G
export(int) var iteraciones # I

var lista_puntos : Array

var rend_linea : Line2D

func _ready() -> void:
	rend_linea = get_node("Line2D")
	rend_linea.points.resize(0)
	
	for s in cantidad_de_segmentos:
		var segmento_anterior : PuntoVerlet
		var altura_segmento_anterior : float
		if lista_puntos.size() == 0:
			altura_segmento_anterior = 0
		else:
			segmento_anterior = lista_puntos[max(s - 1, 0)]
			segmento_anterior.sig_segmento = s
			altura_segmento_anterior = segmento_anterior.pos_actual.y + largo_de_segmento
		
		var pos_punto = Vector2(0, altura_segmento_anterior)
		lista_puntos.append(PuntoVerlet.new(pos_punto))


func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	update()


func _draw() -> void:
	for i in lista_puntos:
		draw_circle(i.pos_actual, 1, Color.yellow)
	renderizar_cuerda()


func agarrar_array_de_vectores_pos_actual() -> PoolVector2Array:
	var arr : PoolVector2Array
	for i in lista_puntos:
		arr.append(i.pos_actual)
	return arr


func renderizar_cuerda():
	rend_linea.points = agarrar_array_de_vectores_pos_actual()






