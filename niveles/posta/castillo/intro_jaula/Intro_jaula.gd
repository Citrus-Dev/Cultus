extends Nivel

export(NodePath) onready var cult_hablar_1 = get_node(cult_hablar_1) as Cultista
export(NodePath) onready var cult_hablar_2 = get_node(cult_hablar_2) as Cultista
export(NodePath) onready var cult_ouch = get_node(cult_ouch) as Cultista
export(NodePath) onready var hurt = get_node(hurt) as TriggerHurt
export(NodePath) onready var jaula = get_node(jaula) as IntroJaula
export(NodePath) onready var target_correr = get_node(target_correr) as Position2D
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_cerrar_puerta = get_node(trigger_cerrar_puerta) as TriggerOnce

func _ready():
	trigger_cerrar_puerta.connect("triggered", puerta, "cerrar")
	
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
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	cult_hablar_1.script_idle({"Anim" : "correr", "CorrerObj" : target_correr, "FlipH" : false})
	yield(get_tree().create_timer(0.1), "timeout")
	cult_hablar_2.script_idle({"Anim" : "correr", "CorrerObj" : target_correr, "FlipH" : false})


func ouch(__):
	hurt.trigger()
	jaula.call_deferred("free")
