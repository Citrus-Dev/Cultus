extends Node2D

const EXPLOSION := preload("res://main/Proyectiles/ExplHEEnemigos.tscn")

var tick: int

export(NodePath) onready var shaker = get_node(shaker) as Shaker


func _ready():
	pass


func _process(delta):
	if tick >= 2:
		shaker.add_trauma(1.0)



func tickear():
	tick += 1
	if tick == 3:
		# Explotar
		var expl: ExplHE = EXPLOSION.instance()
		expl.dmg = 17
		
		get_tree().get_nodes_in_group("Nivel")[0].add_child(expl)
		expl.global_position = global_position
		
		call_deferred("free")
