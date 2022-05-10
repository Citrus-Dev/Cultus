class_name ConsoleGUI
extends CanvasLayer

const MENSAJE_COMANDO_INVALIDO = "Comando no encontrado."
const MENSAJE_ARG_INVALIDOS = "Argumentos inválidos."

export(NodePath) onready var console_feed = get_node(console_feed) as TextEdit
export(NodePath) onready var console_input = get_node(console_input) as LineEdit
export(NodePath) onready var label_nota = get_node(label_nota) as Label

var last_command : String

func _init() -> void:
	ConsoleAutoload.console_control = self
	add_to_group("ConsoleGUI")


func _ready() -> void:
	toggle_visible()
	escribir_label()


func _process(delta: float) -> void:
	if console_input.text != "":
		if Input.is_key_pressed(KEY_ENTER):
			var input = console_input.text.rsplit(" ", false)
			process_command(input)
		
		if Input.is_action_just_pressed(ConsoleAutoload.ACCION_ABRIR_CONSOLA):
			toggle_visible()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_UP):
		console_input.text = last_command
		console_input.caret_position = console_input.text.length()


func process_command(_input : Array):
	if is_instance_valid(console_input):
		console_input.clear()
	
	if _input.size() > 2:
		display_output(MENSAJE_ARG_INVALIDOS)
		return
	
	var comando = _input.pop_front()
	var funcname = "c_" + comando
	if ConsoleAutoload.command_list.has(comando):
		last_command = comando
		var method_owner = ConsoleAutoload.command_list[comando]["owner"]
		var function = funcref(method_owner, funcname)
		var args = cast_args_to_int(_input)
		var return_string = function.call_funcv(_input)
		display_output(return_string)
	else:
		display_output(MENSAJE_COMANDO_INVALIDO)


func cast_args_to_int(_array : Array):
	var new_arr := []
	for i in _array:
		new_arr.append(int(i))
	
	return new_arr


func display_output(_string : String):
	if is_instance_valid(console_feed):
		console_feed.text = str(console_feed.text, "\n", _string)
		console_feed.scroll_vertical += 100


func toggle_visible():
	console_input.clear()
	for i in get_children():
		i.visible = !i.visible
		get_tree().paused = i.visible
		set_process(i.visible)
	if get_tree().paused: console_input.grab_focus()


# Llena label_nota con datos varios (version, etc)
func escribir_label():
	var info = load("res://main/InfoJuego.tres")
	var texto_version = "Versión " + info.version_actual
	var texto_help = "Escribí 'comandos' para una lista de comandos."
	var propiedad = "Propiedad de citro dev, ver créditos."
	
	label_nota.text = texto_version + "\n" + texto_help + "\n" + propiedad

