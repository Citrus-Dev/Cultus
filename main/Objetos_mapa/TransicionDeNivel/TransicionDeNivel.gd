# Al tocarlo pasas a otro nivel
class_name TransicionDeNivel
extends Area2D

const MASCARA = preload("res://main/UI/Transicion/TransicionMascara.tscn")
const TIEMPO_TRANSICION_NIVEL := 0.5

enum DIRS {
	IZQ,
	DER,
	ARRIBA,
	ABAJO
}

export(String) var ID
export(String) var ID_objetivo
export(String) var direccion_nivel
export(DIRS) var direccion_movimiento

var pos_spawn : Position2D

func _ready():
	add_to_group("TriggersTransiciones")
	for child in get_children():
		if child is Position2D:
			pos_spawn = child
	connect("body_entered", self, "colision_jugador")


# cuando tocas el trigger
func colision_jugador(_jug : Jugador):
	if _jug.anim_level_trans:
		return
	
	activar_animacion(_jug, direccion_movimiento)
	yield(get_tree().create_timer(TIEMPO_TRANSICION_NIVEL), "timeout")
	transicion(_jug)


# La animacion de moverse
func activar_animacion(_jug : Jugador, _dir : int):
	mascara_anim(true)
	_jug.anim_level_trans = true
	_jug.input = Vector2.ZERO
	match direccion_movimiento:
		DIRS.DER:
			_jug.input.x = 1
		DIRS.IZQ:
			_jug.input.x = -1
		DIRS.ARRIBA:
			_jug.velocity.y = _jug.jump_velocity


func animacion_de_salida(_jug : Jugador, _direccion : int):
	mascara_anim(false)
	_jug.anim_level_trans = true
	_jug.input = Vector2.ZERO
	match _direccion:
		DIRS.DER:
			_jug.input.x = 1
		DIRS.IZQ:
			_jug.input.x = -1
		DIRS.ARRIBA:
			_jug.velocity.y = _jug.jump_velocity
			_jug.input.x = TransicionesDePantalla.ultima_dir
	yield(get_tree().create_timer(0.5), "timeout")
	_jug.anim_level_trans = false


func transicion(_jug : Jugador):
	TransicionesDePantalla.trigger_objetivo = ID_objetivo
	TransicionesDePantalla.ultima_direccion = direccion_movimiento
	TransicionesDePantalla.ultima_dir = _jug.dir
	TransicionesDePantalla.slot_arma_seleccionado = _jug.controlador_armas.slot_actual
	TransicionesDePantalla.inv_balas_estado = _jug.controlador_armas.inv_balas.dict_balas
	TransicionesDePantalla.inv_armas = _jug.controlador_armas.armas
	get_tree().change_scene(direccion_nivel)


func mascara_anim(_fade_out : bool):
	var mask = MASCARA.instance()
	var nivel = get_tree().get_nodes_in_group("Nivel")[0]
	nivel.add_child(mask)
	
	var final = 0.0
	if _fade_out:
		final = 1.0
		mask.rect.color.a = 0.0
	
	var tween := Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		mask.rect,
		"color:a",
		mask.rect.color.a,
		final,
		TIEMPO_TRANSICION_NIVEL,
		tween.TRANS_LINEAR
	)
	tween.start()
	
	if !_fade_out:
		yield(tween, "tween_all_completed")
		
		tween.call_deferred("free")
		mask.call_deferred("free")

