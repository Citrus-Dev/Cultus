class_name PickupArma
extends Node2D

signal on_pickup

export(NodePath) onready var area = get_node(area) as Area2D
export(String) var id_arma
export(String) var mensaje
export(PackedScene) var pantalla_tutorial

onready var armas := Armas.new()
onready var altura_inicial := position.y

var starting_y: float

func _ready():
	if es_valido():
		printerr("La cagaste")
		call_deferred("free")
	area.connect("body_entered", self, "pickup")
	starting_y = position.y


func _process(delta):
	position.y = anim_levitar(position.y, 0.5 * delta, 1.8)


func anim_levitar(_y :float, _freq : float, _amplitud : float) -> float:
	_y = starting_y + (sin(OS.get_ticks_msec() * _freq) * _amplitud)
	return _y


func anim_tween_levitar():
	pass


func es_valido() -> bool:
	return !armas.armas_lista.has(id_arma)


func pickup(jug : Personaje):
	emit_signal("on_pickup")
	var cont = jug.controlador_armas
#	ControladorUi.emit_signal("mensaje_ui", mensaje, 4.0)
	cont.agregar_arma_string(id_arma)
	call_deferred("free")
	if pantalla_tutorial: spawn_tutorial()


func spawn_tutorial():
	get_tree().root.add_child(pantalla_tutorial.instance())

