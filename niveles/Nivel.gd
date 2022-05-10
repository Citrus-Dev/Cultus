class_name Nivel
extends Node2D

export(NodePath) var primer_limite_camara
export(bool) var print_fps

var primer_limite_camara_obj : CameraBounds

func _init() -> void:
	add_to_group("Nivel")


func _ready():
	if get_tree().get_nodes_in_group("HUD").size() > 0:
		var hud = get_tree().get_nodes_in_group("HUD")[0]
		for i in hud.get_children():
			i.call_deferred("free")
	
	var s_group = get_tree().get_nodes_in_group("SpawnJugador")
	var p_group = get_tree().get_nodes_in_group("Jugador")
	
	if TransicionesDePantalla.muerte:
		TransicionesDePantalla.spawn_jugador_transicion_muerte()
		return
	
	if p_group.size() < 1 and TransicionesDePantalla.trigger_objetivo != "": 
		print("No hay jugador")
		TransicionesDePantalla.spawn_jugador_transicion()
		return
	
	if s_group.size() > 0:
		s_group[0].spawn()


func init_primer_limite():
	if primer_limite_camara:
		primer_limite_camara_obj = get_node(primer_limite_camara)
		primer_limite_camara_obj.get_new_limits(true)


func _process(delta: float) -> void:
	if OS.is_debug_build() and print_fps:
		DebugDraw.set_text("fps", Engine.iterations_per_second)
