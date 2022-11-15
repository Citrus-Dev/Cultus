# Clase creada por las hurtbox, tiene informacion relacionada a un ataque 
# (atacante, daño, tipo de daño, etc)
# El status lo usa para decidir que daño hacer y como.
class_name InfoDmg
extends Reference

enum DMG_TIPOS {
	NORMAL,
	MELEE,
	BALA,
	EXPLOSION,
	FUEGO,
	PLASMA,
	PINCHES,
	APLASTAR
}

var atacante : Node # Lo que esta causando el daño
var objetivo : Node # Lo que esta recibiendo el daño
var dmg_cantidad : int
var dmg_tipo : int
var dmg_stun : int # El daño de stun es separado al daño normal
var fuerza_retroceso : float


func _init(dmg: int = 0):
	dmg_cantidad = dmg



static func puede_gibear(tipo: int) -> bool:
	match tipo:
		DMG_TIPOS.EXPLOSION, DMG_TIPOS.PLASMA, DMG_TIPOS.APLASTAR:
			return true
		_:
			return false

