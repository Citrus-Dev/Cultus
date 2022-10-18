class_name Nivel
extends Node2D

export(NodePath) var primer_limite_camara
export(bool) var print_fps
export(bool) var impulse_automatico
export(Resource) var musica

var primer_limite_camara_obj : CameraBounds
var info_persist_nivel := {} # Guardado de datos persistentes

func _init() -> void:
	add_to_group("Nivel")


func _ready():
	Musica.instantaneo = true
	Musica.asignar_musica(musica)
	GameState.determinar_estado_inicial(self)
	Musica.instantaneo = false
	Musica.set_override(-1)
	
	if Guardado.hay_datos_persist_del_nivel(filename):
		info_persist_nivel = Guardado.tomar_datos_persist_del_nivel(filename)
	
	if !info_persist_nivel.empty():
		var group_pers := get_tree().get_nodes_in_group("Personaje")
		for personaje in group_pers:
			var path = personaje.get_path()
			if info_persist_nivel.has(str(path)):
				var info: Dictionary = info_persist_nivel[str(path)]
				
				if info.has("muerto") and info["muerto"] == true:
					personaje.call_deferred("free")
					continue
				
				for prop in info:
					personaje.set(prop, info_persist_nivel[str(path)][prop])
	
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
	
	ControladorUi.emit_signal("cambiar_salud", ControladorUi.jug_hp)

	yield(get_tree(), "idle_frame")

	if impulse_automatico:
		Comandos.c_impulse_200()


func init_primer_limite():
	if primer_limite_camara:
		primer_limite_camara_obj = get_node(primer_limite_camara)
		primer_limite_camara_obj.get_new_limits(true)


func cambiar_limites_camara(limite : CameraBounds):
	limite.get_new_limits(false)


func _process(delta: float) -> void:
	if OS.is_debug_build() and print_fps:
		DebugDraw.set_text("fps", Engine.iterations_per_second)


func agregar_dato_persistente(path : String, datos : Dictionary):
	info_persist_nivel[path] = datos


func cargar_estado_persistente(estado : Dictionary):
	info_persist_nivel = estado
	for i in estado:
		pass


func guardar_datos_persistentes():
	Guardado.info_persist_global[filename] = info_persist_nivel


func _exit_tree():
	guardar_datos_persistentes()


func alertar_todos_los_enemigos():
	var p = get_tree().get_nodes_in_group("Jugador")[0]
	for i in get_tree().get_nodes_in_group("Enemigos"):
		i.objetivo = p
		i.emit_signal("objetivo_encontrado")

