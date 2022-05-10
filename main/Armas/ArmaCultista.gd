class_name ArmaCultista
extends Arma

const BALA_CULT = preload("res://main/Proyectiles/ProyCultista.tscn")

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinShotgun.tscn")
	casquillo_escena = preload("res://main/Efectos/Casquillos/CasquilloBase.tscn")
	damage_info.dmg_cantidad = 5
	damage_info.fuerza_retroceso = 100
	damage_info.dmg_stun = 15
	
	automatica = true
	cooldown_tiempo = 0.1
	recoil_visual_duracion = 0.2
	spread = 5
	screenshake = 2.5


func disparar(_origin : Node, _dir : float):
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	eyectar_casquillo(_dir)
	crear_bala(_origin, BALA_CULT, _dir, spread)
