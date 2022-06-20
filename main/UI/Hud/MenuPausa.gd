class_name MenuPausa
extends CanvasLayer

signal resumido

export(NodePath) onready var but_resumir = get_node(but_resumir) as Button
export(NodePath) onready var but_opciones = get_node(but_opciones) as Button
export(NodePath) onready var but_quit_menu = get_node(but_quit_menu) as Button
export(NodePath) onready var but_quit_desk = get_node(but_quit_desk) as Button


func resumir():
	emit_signal("resumido")


func mostrar_opciones():
	pass


func quit_menu():
	Guardado.guardar_partida(Guardado.slot_actual)
	get_tree().change_scene("res://niveles/menu/MainMenu.tscn")
	emit_signal("resumido")


func quit_desk():
	Guardado.guardar_partida(Guardado.slot_actual)
	get_tree().quit()


func _enter_tree() -> void:
	get_tree().paused = true
	get_tree()


func _exit_tree() -> void:
	get_tree().paused = false
