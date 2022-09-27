extends Node

signal set_up_finished

const CONSOLE_SCENE = preload("res://main/libs/Consola/ConsoleGUI.tscn")
const ACCION_ABRIR_CONSOLA := "abrir_consola"
const AUTOLOADS_DISPONIBLES := [
	"Comandos"
]

var console_control : ConsoleGUI
var console_toggle_input : bool
var command_list := {}

func _ready() -> void:
	# Si no es una build debug sacamos la consola
#	if !ProjectSettings.get_setting("global/consola"):
	if !OS.is_debug_build():
		call_deferred("free")
		return
	
	pause_mode = PAUSE_MODE_PROCESS
	var console_inst = CONSOLE_SCENE.instance()
	get_tree().get_root().call_deferred("add_child", console_inst)
	get_command_list()
	
	emit_signal("set_up_finished")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(ACCION_ABRIR_CONSOLA):
		console_control.toggle_visible()


# Loops through every autoload available and looks for methods that start with c_
func get_command_list():
	var als_list := [] # Autoloads with names that match the available autoloads list
	for i in AUTOLOADS_DISPONIBLES:
		for node in get_tree().get_root().get_children():
			if node.name == i:
				als_list.append(node)
	
	for autoload in als_list:
		for m in autoload.get_method_list():
			if m.name.begins_with("c_"):
				command_list[m.name.trim_prefix("c_")] = {
					"owner" : autoload
				}


func add_node_comands(_node):
	for m in _node.get_method_list():
		if m.name.begins_with("c_"):
			command_list[m.name.trim_prefix("c_")] = {
				"owner" : _node
			}




