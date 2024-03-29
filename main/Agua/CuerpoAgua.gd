class_name CuerpoAgua
extends Node2D

const COL_AGUA = preload("res://main/Agua/ColisionadorAgua.tscn")

export(int) var cantidad_de_puntos
export(float) var largo
var distancia_entre_puntos : float
export(float) var altura = 12
export(float) var ancho_superficie
export(float, 0, 0.9) var spread = 0.1
export(Color) var color_agua
export(Color) var color_superficie
export(bool) var debug
export(bool) var mov_random 
export(float) var intervalo_movimiento_random = 2 # Cada X tiempo mover un resorte al azar
export(float) var fuerza_movimiento_random = 20 # Con Y fuerza
export(float) var resorte_dureza = 0.025
export(float) var resorte_damp = 0.025
export(int, 1, 8) var iteraciones = 1

var line_rend : Line2D
var polygons := []
var puntos := []
var mouse_x_pos : float
var mov_random_timer : float

func _draw():
	for poly in polygons:
		draw_colored_polygon(poly, color_agua)
	
	if !debug: return
	
	var pos_pasada := Vector2(0, -altura)
	for i in puntos:
		if is_equal_approx(mouse_x_pos, i.global_position.x):
			draw_circle(i.position, 3.0, Color.green)
		else:
			draw_circle(i.position, 1.0, Color.yellow)
		draw_line(i.position, pos_pasada, Color.blue, 1.0)
		pos_pasada = i.position
	
	draw_line(Vector2.ZERO, Vector2((cantidad_de_puntos * distancia_entre_puntos), 0), Color.white, 1.0)


func _process(delta):
	for i in iteraciones:
		propagacion()
	actualizar_render_polygon()
	actualizar_linea()
	if mov_random: movimiento_random(delta)
	update()


func _ready():
	distancia_entre_puntos = largo / cantidad_de_puntos
	
	for i in cantidad_de_puntos + 1:
		var resorte = Resorte.new()
		add_child(resorte)
		resorte.STIFFNESS = resorte_dureza
		resorte.FACTOR_DAMP = resorte_damp
		resorte.global_position.x += i * distancia_entre_puntos
		resorte.position.y = -altura
		puntos.append(resorte)
		resorte.init_target_pos()
	
	actualizar_render_polygon()
	
	crear_col_agua(puntos[0], puntos[cantidad_de_puntos])
	
	call_deferred("crear_linea")


func actualizar_render_polygon():
	polygons.clear()
	for i in cantidad_de_puntos:
		if i != cantidad_de_puntos:
			var lista : PoolVector2Array
			
			var pos_punto_izq = (puntos[i].position)
			var pos_punto_der = (puntos[i + 1].position)
			
			lista.append(pos_punto_izq)
			lista.append(pos_punto_der)
			lista.append(Vector2(pos_punto_der.x, 0))
			lista.append(Vector2(pos_punto_izq.x, 0))
			
			polygons.append(lista)


func crear_linea():
	line_rend = Line2D.new()
	add_child(line_rend)
	line_rend.width = ancho_superficie
	line_rend.default_color = color_superficie
	actualizar_linea()


func actualizar_linea():
	var points_nuevo : PoolVector2Array
	for punto in puntos:
		points_nuevo.append(punto.position)
	line_rend.points = points_nuevo


func crear_col_agua(_punto_izq : Resorte, _punto_der : Resorte):
	var col = COL_AGUA.instance() as ColisionadorAgua
	col.punto_der = _punto_der
	col.punto_izq = _punto_izq
	col.polygon_color = color_agua
	col.connect("splash_signal", self, "splash")
	add_child(col)


func splash(fuerza : float, mult : float, pos : float):
	for punto_index in cantidad_de_puntos:
		var punto_actual : Resorte = puntos[punto_index]
		var otro_punto : Resorte
		if punto_index < cantidad_de_puntos:
			otro_punto = puntos[punto_index + 1]
		else: return
		
		if pos > punto_actual.global_position.x and pos < otro_punto.global_position.x:
			punto_actual.velocity.y = fuerza * mult
			otro_punto.velocity.y = fuerza * mult


# Mueve el agua aleatoriamente para que no este siempre quieta
func movimiento_random(_delta : float):
	if mov_random_timer <= 0:
		var p = puntos[rand_range(0, puntos.size())]
		p.position.y += fuerza_movimiento_random * _delta
	else:
		mov_random_timer -= _delta


func propagacion():
	# Diferencia del altura entre cada resorte y el que tiene a la izq/der
	var deltas_izq := []
	deltas_izq.resize(puntos.size())
	var deltas_der := []
	deltas_der.resize(puntos.size())
	
	for iteracion in 1:
		for i in puntos.size():
			if i > 0: # Todos salvo el primero porque no tiene nada a la izquierda
				deltas_izq[i] = spread * (puntos[i].position.y - puntos[i - 1].position.y)
				puntos[i - 1].velocity.y += deltas_izq[i]
			if i < puntos.size() - 1: # Todos salvo el ultimo porque no tiene nada a la izquierda.
				deltas_der[i] = spread * (puntos[i].position.y - puntos[i + 1].position.y)
				puntos[i + 1].velocity.y += deltas_der[i]





















