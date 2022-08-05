class_name PickupArma
extends Node2D

signal on_pickup

export(NodePath) onready var area = get_node(area) as Area2D
export(String) var id_arma
export(String) var mensaje
export(PackedScene) var pantalla_tutorial

onready var armas := Armas.new()
onready var altura_inicial := position.y

func _ready():
	if es_valido():
		printerr("La cagaste")
		call_deferred("free")
	area.connect("body_entered", self, "pickup")


func _process(delta):
	position.y = anim_levitar(position.y, 0.4 * delta, 0.3)


func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x


func es_valido() -> bool:
	return !armas.armas_lista.has(id_arma)


func pickup(jug : Personaje):
	emit_signal("on_pickup")
	var cont : ControladorArmasJugador = jug.controlador_armas
#	ControladorUi.emit_signal("mensaje_ui", mensaje, 4.0)
	cont.agregar_arma_string(id_arma)
	call_deferred("free")
	spawn_tutorial()


func spawn_tutorial():
	get_tree().root.add_child(pantalla_tutorial.instance())

