extends Nivel

export(NodePath) var path_cult1
export(NodePath) var path_cult2
export(NodePath) var path_trigger
export(NodePath) var correr_obj_path

var cult1 : Cultista
var cult2 : Cultista
var trigger : Area2D
var correr_obj : Node2D

func _ready():
	yield(get_tree(), "idle_frame")
	
	cult1 = get_node(path_cult1)
	cult2 = get_node(path_cult2)
	trigger = get_node(path_trigger)
	correr_obj = get_node(correr_obj_path)
	
	cult1.script_idle({"Anim" : "idle"})
	cult2.script_idle({"Anim" : "idle", "FlipH" : true})
	
	trigger.connect("body_entered", self, "comenzar_anim_mirar", [], 4)


func comenzar_anim_mirar(__):
	cult1.script_idle({"Anim" : "mirar"})
	cult2.script_idle({"Anim" : "mirar", "FlipH" : true})
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	cult1.script_idle({"Anim" : "mirar_der"})
	cult2.script_idle({"Anim" : "mirar_der", "FlipH" : true})
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	cult1.script_idle({"Anim" : "mirar"})
	cult2.script_idle({"Anim" : "mirar", "FlipH" : true})
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	cult2.script_idle({"Anim" : "correr", "CorrerObj" : correr_obj, "FlipH" : false})
	yield(get_tree().create_timer(0.2), "timeout")
	cult1.script_idle({"Anim" : "correr", "CorrerObj" : correr_obj, "FlipH" : false})
	
	
	yield(get_tree().create_timer(3), "timeout")
	cult1.call_deferred("free")
	cult2.call_deferred("free")
