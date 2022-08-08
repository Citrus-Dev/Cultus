# Nodo que controla la vida y buffs / debuffs
class_name Status
extends Node

# El tiempo que tiene que pasar sin recibir daño para que empiece a bajar el stun
const TIEMPO_REDUCCION_STUN := 1.0
const VELOCIDAD_REDUCCION_STUN := 120.0

signal morir
signal morir_info(_info) # Igual que morir pero pasa la info del ultimo daño recibido
signal aplicar_dmg(_info)
signal aplicar_knockback(_fuerza, _dir)
signal aplicar_stun
signal stun_terminado

export(int) var hp_max
export(int) var stun_threshold # Cuando el stun actual pasa este valor, stunea
export(NodePath) onready var agente = get_node(agente)

var hp : int
var stun_actual : float

var timer_stun := Timer.new()

func _ready() -> void:
	init_base()


func init_base():
	add_child(timer_stun)
	timer_stun.one_shot = true
	timer_stun.wait_time = TIEMPO_REDUCCION_STUN
	
	hp = hp_max
	actualizar_hp_bar()


func _process(delta: float) -> void:
	if timer_stun.is_stopped():
		if stun_actual > 0:
			stun_actual -= VELOCIDAD_REDUCCION_STUN * delta
			if stun_actual <= 0:
				emit_signal("stun_terminado")
		else:
			stun_actual = 0


func aplicar_dmg(_info : InfoDmg):
	hp = max(hp - _info.dmg_cantidad, 0)
	actualizar_hp_bar()
	
	emit_signal("aplicar_dmg", _info)
	if hp == 0:
		emit_signal("morir")
		emit_signal("morir_info", _info)
	if _info.fuerza_retroceso != 0:
		var dir
		if _info.atacante.has_method("tomar_centro") and agente.has_method("tomar_centro"):
			var pos_atacante = _info.atacante.tomar_centro()
			var pos_agente = agente.tomar_centro()
			dir = pos_agente - pos_atacante
		else:
			var pos_atacante = _info.atacante.global_position
			var pos_agente = agente.global_position
			dir = pos_agente - pos_atacante
		emit_signal("aplicar_knockback", _info.fuerza_retroceso, dir)
	if _info.dmg_stun:
		stun_actual += _info.dmg_stun
		timer_stun.start()
		if stun_actual >= stun_threshold:
			stun_actual = 0
			emit_signal("aplicar_stun")


func curar(_cantidad : int = hp_max):
	hp = min(hp + _cantidad, hp_max)
	actualizar_hp_bar()


# Solo sirve si el dueño es el jugador
func actualizar_hp_bar():
	if !owner.is_in_group("Jugador"):
		return
	ControladorUi.emit_signal("cambiar_salud", hp)


