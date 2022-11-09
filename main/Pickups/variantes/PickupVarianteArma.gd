class_name PickupVarianteArma
extends Node2D

const ESCENA_TUT := preload("res://main/UI/Hud/tutoriales/pantalla_tutorial_variantes.tscn")

signal agarrado

export(String) var arma
export(NodePath) var sprite_path
export(int) var id_variante
export(PackedScene) var pantalla_tutorial

var sprite: Sprite
var starting_y: float

func _ready():
	$Area2D.connect("body_entered", self, "agarrar")
	if sprite_path: sprite = get_node(sprite_path)
	
	starting_y = position.y


func _process(delta):
	position.y = anim_levitar(position.y, 0.5 * delta, 1.8)


func agarrar(jug: Personaje):
	
	emit_signal("agarrado")
	
	if !GameState.vio_tutorial_variantes:
		var pant := ESCENA_TUT.instance()
		get_tree().root.add_child(pant)
		
		yield(pant, "continuado")
		
		GameState.vio_tutorial_variantes = true
		
		yield(get_tree(), "idle_frame")
	
	if !TransicionesDePantalla.inv_variantes.has( convertir_nombre_arma_a_id(arma) ):
		TransicionesDePantalla.inv_variantes[arma] = []
	
	TransicionesDePantalla.inv_variantes[arma].append(id_variante)
	
	if pantalla_tutorial: spawn_tutorial()
	
	
	if !TransicionesDePantalla.inv_armas.has( convertir_nombre_arma_a_id(arma) ):
		ControladorUi.mensaje_ui(
			"Atencion: Agarraste una variante para un arma que aun no encontraste",
			2.5,
			true
		)
	
	
	call_deferred("free")



func anim_levitar(_y :float, _freq : float, _amplitud : float) -> float:
	_y = starting_y + (sin(OS.get_ticks_msec() * _freq) * _amplitud)
	return _y


func spawn_tutorial():
	get_tree().root.add_child(pantalla_tutorial.instance())


func convertir_nombre_arma_a_id(nombre: String) -> String:
	match nombre:
		"ArmaAR":
			return "RIFLE"
		"ArmaBallesta":
			return "BALLESTA"
		"ArmaRevolver":
			return "PISTOLA"
		"ArmaEscopeta":
			return "ESCOPETA"
		"ArmaGauss":
			return "BAZUCA"
		_:
			return "?"
	
