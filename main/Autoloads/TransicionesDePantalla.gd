extends Node

const JUGADOR_SCENE = preload("res://main/Personajes/Jugador/Jugador.tscn")

var checkpoint_actual_escena : String
var muerte : bool

# ID de la transicion de nivel donde tenes que aparecer cuando 
# pases a otro nivel
var trigger_objetivo : String
var ultima_direccion : int
var ultima_dir : int
var slot_arma_seleccionado : String
var inv_balas_estado : Dictionary
var inv_armas : Dictionary
var inv_variantes : Dictionary
var inv_skills : Dictionary
var ultimo_punto_seguro : Vector2

func spawn_jugador_transicion():
	var trigger_objetivo_nodo = encontrar_trigger_objetivo()
	if trigger_objetivo_nodo == null:
		printerr("wtf!!!!!!!!! quien fue el pelotudo que hizo mal la transicion denivel!!!!!!")
		return  
	var juginst = JUGADOR_SCENE.instance()
	var nivel = get_tree().get_nodes_in_group("Nivel")[0]
	juginst.global_position = trigger_objetivo_nodo.global_position
	nivel.add_child(juginst)
	juginst.anim_level_trans = true
	trigger_objetivo_nodo.animacion_de_salida(juginst, ultima_direccion)
	juginst.controlador_armas.inv_balas.dict_balas = inv_balas_estado
	juginst.status.hp = ControladorUi.jug_hp
	
	yield(get_tree(), "idle_frame")
	juginst.controlador_armas.seleccionar_arma(slot_arma_seleccionado)


func spawn_jugador_transicion_muerte():
	muerte = false
	var check = encontrar_checkpoint()
	if check == null: 
		printerr("ERROR: de alguna forma un nivel sin checkpoint se guardó como checkpoint (que)")
		return
	var juginst = JUGADOR_SCENE.instance()
	var nivel = get_tree().get_nodes_in_group("Nivel")[0]
	juginst.global_position = check.global_position
	nivel.add_child(juginst)
	yield(get_tree(), "idle_frame")
	juginst.controlador_armas.inv_balas.dict_balas = inv_balas_estado


func encontrar_trigger_objetivo() -> TransicionDeNivel:
	var tran_group = get_tree().get_nodes_in_group("TriggersTransiciones")
	for i in tran_group:
		if i.ID == trigger_objetivo:
			return i
	return null


func encontrar_checkpoint() -> Checkpoint:
	var check_g = get_tree().get_nodes_in_group("Checkpoints")
	if check_g.size() > 0:
		return check_g[0]
	else:
		return null

