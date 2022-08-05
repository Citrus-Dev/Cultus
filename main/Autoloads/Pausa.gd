extends Node

const PAUSA_ESCENA = preload("res://main/UI/Hud/MenuPausa.tscn")

var pausa_inst : MenuPausa

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS


func procesar_pausa(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if pausa_inst == null:
			instanciar_pausa()
		else:
			borrar_pausa()


func instanciar_pausa():
	pausa_inst = PAUSA_ESCENA.instance()
	get_tree().root.add_child(pausa_inst)
	pausa_inst.connect("resumido", self, "borrar_pausa")


func borrar_pausa():
	pausa_inst.queue_free()
	pausa_inst = null


