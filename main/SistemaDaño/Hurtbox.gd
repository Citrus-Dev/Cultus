class_name Hurtbox
extends Area2D

signal dmg_aplicado

# TODO reemplazar estas variables por un recurso InfoDmg
export(NodePath) var agente_dir
export(bool) var is_constant
export(int) var dmg = 1
export(float) var fuerza_retroceso = 0.0
export(InfoDmg.DMG_TIPOS) var dmg_tipo 
export(float) var cooldown_de_dmg

var agente : Node
var desactivado : bool
var timer_cooldown : float

func _ready() -> void:
	if agente_dir != "":
		agente = get_node(agente_dir)
	else:
		agente = owner


func _process(delta: float) -> void:
	if desactivado or !is_constant: return
	
	if timer_cooldown > 0:
		timer_cooldown -= delta
	
	if has_valid_targets():
		deal_damage(dmg)


func has_valid_targets() -> bool:
	for i in get_overlapping_areas():
		if i is Hitbox:
			return true 
	return false


func deal_damage(_dmg : int):
	if timer_cooldown > 0: return
	
	for i in get_overlapping_areas():
		if i is Hitbox:
			var dmg_info = InfoDmg.new()
			dmg_info.atacante = agente
			dmg_info.objetivo = i.owner
			dmg_info.dmg_cantidad = _dmg
			dmg_info.fuerza_retroceso = fuerza_retroceso
			dmg_info.dmg_tipo = dmg_tipo
			
			i.recibir_dmg(dmg_info)
			emit_signal("dmg_aplicado")
	
	timer_cooldown = cooldown_de_dmg

