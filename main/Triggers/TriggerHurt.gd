class_name TriggerHurt
extends Area2D

enum DMG_TIPOS {
	NORMAL,
	MELEE,
	BALA,
	EXPLOSION,
	FUEGO,
	PLASMA
}

export(int) var dmg
export(DMG_TIPOS) var dmg_tipo
export(bool) var siempre_activo = true


func _ready():
	if siempre_activo: connect("body_entered", self, "hurt")


func trigger():
	for c in get_overlapping_bodies():
		hurt(c)


func hurt(victima : Personaje):
	var status : Status = victima.status
	var info = InfoDmg.new()
	
	info.dmg_cantidad = dmg
	info.dmg_tipo = dmg_tipo
	
	status.aplicar_dmg(info)
