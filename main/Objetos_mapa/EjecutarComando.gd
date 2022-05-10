# Llama un comando cuando empieza el nivel.
# NO FUNCA :(
# NO FUNCA :(
# NO FUNCA :(
# NO FUNCA :(
# NO FUNCA :(
# NO FUNCA :(
class_name EjecutorComando
extends Node

export(String) var comando
export(String) var arg

func _ready() -> void:
	var console = ConsoleAutoload.console_control as ConsoleGUI
	print_debug(console.process_command([comando, arg]))

