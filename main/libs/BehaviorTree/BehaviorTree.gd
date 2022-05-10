class_name BehaviorTree, "res://main/libs/BehaviorTree/icons/tree.svg"
extends BTBase

enum PROCESOS {
	FRAMERATE,
	FISICAS
}

export(NodePath) onready var agente = get_node(agente)
export(bool) var debug_print 

var blackboard := Blackboard.new()
export(bool) var activado = true setget set_activado
#export(PROCESOS) var tipo_de_proceso
var nodo_procesando : Node

func _ready() -> void:
	set_activado(activado)
	if get_child_count() != 1:
		print_debug("ERROR: La raíz del arbol debe tener un solo hijo.")
		call_deferred("free")
		return


func _physics_process(delta: float) -> void:
	blackboard.escribir_dato("delta", delta)
	if debug_print: DebugDraw.set_text("blackboard", blackboard.datos)
	tick()


func tick(_agente : Node = agente, _blackboard : Blackboard = blackboard):
	var result = get_child(0).tick(_agente, _blackboard)
	return result


func set_activado(_bool : bool):
	activado = _bool
	set_process(activado)
	set_physics_process(activado)
