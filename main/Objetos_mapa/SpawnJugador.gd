tool
class_name SpawnJugador
extends Node2D

const JUGADOR_SCENE = preload("res://main/Personajes/Jugador/Jugador.tscn")
const JUGADOR_TEXTURA = preload("res://assets/texturas/SpriteJug.tres")

func _init():
	add_to_group("SpawnJugador")


func _draw() -> void:
	if Engine.editor_hint:
		draw_texture(JUGADOR_TEXTURA, Vector2(), Color(1, 1, 1, 0.4))


func spawn():
	var inst = JUGADOR_SCENE.instance()
	inst.global_position = global_position
	get_parent().add_child(inst)
