class_name ArmaRevolverEsqueleto
extends Arma

const BALA = preload("res://main/Proyectiles/BalaRevolverEsqueleto.tscn")
const SONIDO_DISPARO := preload("res://assets/sfx/armas/disparo/Barrett-M82-.50-BMG-Single-Close-Gunshot-A-www.fesliyanstudios.com.wav")

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinRevolverEsqueleto.tscn")
	damage_info.dmg_cantidad = 10
	damage_info.fuerza_retroceso = 100
	damage_info.dmg_stun = 25
	
	automatica = true
	cooldown_tiempo = 0.5
	recoil_visual_duracion = 0.2
	spread = 2
	screenshake = 2.5
	
	ia_largo_rafaga = 1


func disparar(_origin : Node, _dir : float):
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	eyectar_casquillo(_dir)
	crear_bala(_origin, BALA, _dir, spread)
	Musica.hacer_sonido(SONIDO_DISPARO, _origin.global_position)
