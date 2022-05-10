# Aplica colisiones al agua
class_name ColisionadorAgua
extends Area2D

signal tocado(_vector_movimiento)

export(Color) var polygon_color

var collider : CollisionPolygon2D
var polygon : Polygon2D
var punto_izq : Resorte
var punto_der : Resorte
var pie_izq : Vector2
var pie_der : Vector2

var fuerza_de_entrada : float = 2

func _draw() -> void:
	return
	draw_circle(punto_der.position, 2.0, Color.pink)
	draw_circle(punto_izq.position, 2.0, Color.pink)
	draw_circle(pie_izq, 2.0, Color.orange)
	draw_circle(pie_der, 2.0, Color.purple)


func _ready() -> void:
	pie_izq = Vector2(punto_izq.position.x, 0)
	pie_der = Vector2(punto_der.position.x, 0)
	
	collider = get_child(0)
	
	polygon = Polygon2D.new()
	add_child(polygon)
	polygon.color = polygon_color


func _physics_process(delta: float) -> void:
	update()
	collider.polygon[0] = punto_izq.position
	collider.polygon[1] = punto_der.position
	collider.polygon[2] = pie_der
	collider.polygon[3] = pie_izq
	
	polygon.polygon = collider.polygon
	
	for body in get_overlapping_bodies():
		if !body.is_in_group("CuerposEnAgua"):
			body.add_to_group("CuerposEnAgua")


func tomar_fuerza_de_entrada(_obj) -> float:
	var fuerza = _obj.get("fuerza_de_entrada")
	if fuerza == null:
		fuerza = fuerza_de_entrada
	return fuerza


func entrar_en_agua(_cuerpo : KinematicBody2D):
	_cuerpo.add_to_group("CuerposEnAgua")
	
	if can_splash(_cuerpo):
		splash(_cuerpo, 1)


func salir_del_agua(_cuerpo : KinematicBody2D):
	if _cuerpo.is_in_group("CuerposEnAgua"):
		_cuerpo.remove_from_group("CuerposEnAgua")
	
	if can_splash(_cuerpo):
		splash(_cuerpo, -1)


func can_splash(_cuerpo : KinematicBody2D) -> bool:
	if _cuerpo is Personaje:
		return true
	if _cuerpo is ProyectilBase:
		return true
	
	return false


func splash(_cuerpo : KinematicBody2D, _mult : int):
	var mov := Vector2()
	if _cuerpo.get("velocity") != null:
		mov = _cuerpo.velocity
	if !es_vertical(mov) and !_cuerpo is ProyectilBase: return
	
	var f = tomar_fuerza_de_entrada(_cuerpo)
	
	emit_signal("tocado", mov)
	punto_izq.velocity.y = f * _mult
	punto_der.velocity.y = f * _mult


# Detecta si un vector de movimiento esta llendo para abajo o arriba
func es_vertical(_vec : Vector2) -> bool:
	var angle = rad2deg(_vec.angle())
	var angle_step = stepify(angle, 90)
	var new_vec = Vector2.RIGHT.rotated(deg2rad(angle_step))
	
	if new_vec.length() < 0.5: return false
	
	var result = new_vec.y == 1 or new_vec.y == -1
	return result


