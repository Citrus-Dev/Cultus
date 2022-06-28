class_name Ballesta
extends Arma

const BALA = preload("res://main/Proyectiles/Flecha.tscn")

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinBallesta.tscn")
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasNoRecarga.tscn")
	damage_info.dmg_cantidad = 7500000
	damage_info.dmg_stun = 120
	damage_info.fuerza_retroceso = 150
	damage_info.dmg_tipo = damage_info.DMG_TIPOS.BALA
	nombre = "ArmaBallesta"
	
	cooldown_tiempo = 0.8
	slot = SLOTS.BALLESTA


func disparar(_origin : Node, _dir : float):
	if !puede_disparar(): 
		return
	
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	crear_bala(_origin, BALA, _dir, spread)
	_origin.inv_balas.bajar_balas(1, "Flechas")
	actualizar_medidor()


func puede_disparar() -> bool:
	return inv_balas.hay_balas("Flechas")


func instanciar_medidor(_inv_balas : InvBalas, _hud : CanvasLayer) -> Control:
	if !medidor_balas_escena: return null
	
	inv_balas = _inv_balas
	hud_medidor_inst = medidor_balas_escena.instance()
	hud_medidor_inst.bala_textura = preload("res://assets/ui/balas/hud_bala_icono_flecha.tres")
	hud_medidor_inst.id_balas = "Flechas"
	var tipo = hud_medidor_inst.id_balas
	_hud.add_child(hud_medidor_inst)
	
	hud_medidor_inst.init_barra(_inv_balas.dict_balas[tipo]["max"], _inv_balas.dict_balas[tipo]["cant"])
	return hud_medidor_inst


func actualizar_medidor():
	var tipo = hud_medidor_inst.id_balas
	hud_medidor_inst.set_cantidad(inv_balas.dict_balas[tipo]["cant"])
