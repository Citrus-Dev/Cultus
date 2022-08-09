class_name Explosion
extends Node2D

export(NodePath) var los_check_path
export(String, "Enemigos", "Jugador", "Ambos") var equipo
export(int) var dmg
export(int) var dmg_stun
export(float) var radio

onready var los_check = get_node(los_check_path) as LOSCheck

var info_dmg : InfoDmg

func _ready():
	los_check.radio = radio
	var col : int
	match equipo:
		"Enemigos":
			col = 16
		"Jugador":
			col = 32
		"Ambos":
			col = 16 + 32
	los_check.check_areas = true
	los_check.mascara_colision = col
	
	los_check.init()
	
	info_dmg = InfoDmg.new()
	info_dmg.dmg_cantidad = dmg
	info_dmg.dmg_tipo = info_dmg.DMG_TIPOS.EXPLOSION
	info_dmg.dmg_stun = dmg_stun
	info_dmg.fuerza_retroceso = radio * 3
	info_dmg.atacante = self
	
	yield(get_tree(), "idle_frame")
	for hitb in los_check.get_overlapping_areas():
		var h = hitb as Hitbox
		h.recibir_dmg(info_dmg)
	call_deferred("free")

