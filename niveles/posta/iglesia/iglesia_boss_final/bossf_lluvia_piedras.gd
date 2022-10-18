class_name BossfLluviaPiedras
extends Node2D


const ESCENA_PIEDRA: PackedScene = preload("res://niveles/posta/iglesia/iglesia_boss_final/Piedra.tscn")
const PIEDRAS_POR_LLUVIA: int = 16
const TIEMPO_ENTRE_PIEDRAS: float = 0.2

export var espacio: float

var timer: Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)




func llover():
	
	var c: CamaraReal = get_tree().get_nodes_in_group("Camara")[0]
	for i in range(10):
		c.aplicar_screenshake(2.0)
		
		timer.start(0.2)
		yield(timer, "timeout")
	
	
	for i in PIEDRAS_POR_LLUVIA:
		var inst: Node2D = ESCENA_PIEDRA.instance()
		inst.position.x = rand_range(-espacio, espacio)
		add_child(inst)
		
		timer.start(TIEMPO_ENTRE_PIEDRAS)
		yield(timer, "timeout")


