class_name PickupVarianteArma
extends Node2D

const ESCENA_TUT := preload("res://main/UI/Hud/tutoriales/pantalla_tutorial_variantes.tscn")

signal agarrado

export(String) var arma
export(NodePath) var sprite_path
export(int) var id_variante

var sprite: Sprite

func _ready():
	$Area2D.connect("body_entered", self, "agarrar")
	if sprite_path: sprite = get_node(sprite_path)


func _process(delta):
	if is_instance_valid(sprite):
		sprite.position.y = anim_levitar(sprite.position.y, 0.4 * delta, 0.3)


func agarrar(jug: Jugador):
	emit_signal("agarrado")
	if !TransicionesDePantalla.inv_variantes.has(arma):
		TransicionesDePantalla.inv_variantes[arma] = []
	TransicionesDePantalla.inv_variantes[arma].append(id_variante)
	
	if !GameState.vio_tutorial_variantes:
		get_tree().root.add_child(ESCENA_TUT.instance())
		GameState.vio_tutorial_variantes = true
	
	call_deferred("free")


func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x
