extends Nivel

export(NodePath) onready var cult_hablar_1 = get_node(cult_hablar_1) as Cultista
export(NodePath) onready var cult_hablar_2 = get_node(cult_hablar_2) as Cultista
export(NodePath) onready var cult_ouch = get_node(cult_ouch) as Cultista
export(NodePath) onready var hurt = get_node(hurt) as TriggerHurt

func _ready():
	yield(get_tree(), "idle_frame")
	
	cult_hablar_1.set_es_actor(true)
	cult_hablar_1.script_idle({"Anim" : "idle", "FlipH" : true})
	
	cult_hablar_2.set_es_actor(true)
	cult_hablar_2.script_idle({"Anim" : "idle", "FlipH" : false})
	
	cult_ouch.set_es_actor(true)
	cult_ouch.script_idle({"Anim" : "idle", "FlipH" : true})


func asustar():
	cult_hablar_1.script_idle({"Anim" : "idle", "FlipH" : true})
	cult_hablar_2.script_idle({"Anim" : "idle", "FlipH" : true})
	
	cult_hablar_1.stretcher.stretch(Vector2(0.7, 1.3), 0.5)
	cult_hablar_2.stretcher.stretch(Vector2(0.7, 1.3), 0.5)


func ouch(__):
	hurt.trigger()
