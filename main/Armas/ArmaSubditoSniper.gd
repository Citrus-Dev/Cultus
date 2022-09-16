class_name ArmaSubditoSniper
extends Arma

const BALA = preload("res://main/Proyectiles/BalaSniper.tscn")

var linea: Line2D

func _init():
	skin_escena = preload("res://main/Armas/Skins/SkinAR.tscn")
	casquillo_escena = preload("res://main/Efectos/Casquillos/CasquilloBase.tscn")
	damage_info.dmg_cantidad = 40
	damage_info.fuerza_retroceso = 500
	damage_info.dmg_stun = 100
	
	automatica = true
	cooldown_tiempo = 0.5
	recoil_visual_duracion = 0.2
	spread = 2
	screenshake = 2.5
	
	ia_largo_rafaga = 1



func disparar(_origin : Node, _dir : float):
#	if skin_inst != null:
#		skin_inst.animador.stop()
#		skin_inst.animador.play("disparar")
	eyectar_casquillo(_dir)
	crear_bala(_origin, BALA, _dir, spread)


