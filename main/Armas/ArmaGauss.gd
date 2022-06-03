class_name Gauss
extends Arma

const BALA = preload("res://main/Proyectiles/ProyectilGauss.tscn")

func _init() -> void:
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasGauss.tscn")
	skin_escena = preload("res://main/Armas/Skins/SkinGauss.tscn")
	damage_info.dmg_cantidad = 120
	damage_info.dmg_stun = 250
	damage_info.fuerza_retroceso = 250
	damage_info.dmg_tipo = damage_info.DMG_TIPOS.PLASMA
	
	cooldown_tiempo = 1.2
	slot = SLOTS.BAZUCA


func puede_disparar() -> bool:
	return inv_balas.hay_balas("Cohetes")


func disparar(_origin : Node, _dir : float):
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	
	crear_bala(_origin, BALA, _dir, spread)
#	dibujar_hitscan(_origin, _dir)
	
	_origin.inv_balas.bajar_balas(1, "Cohetes")
	actualizar_medidor()
	usador.aplicar_knockback(350, -Vector2.RIGHT.rotated(_dir))


func dibujar_hitscan(_origin : Node, _dir : float):
	var space = usador.get_world_2d().direct_space_state
	var hitscan = space.intersect_ray(
		_origin.global_position,
		_origin.global_position + Vector2.RIGHT.rotated(_dir) * 1000,
		[usador],
		1
	)
	
	var estela = AntialiasedLine2D.new()
	estela.points.resize(2)
#	estela.points[0] = _origin.global_position
#	estela.points[1] = hitscan["position"]
	estela.points.append(_origin.global_position)
	estela.points.append(hitscan["position"])
	_origin.add_child(estela)


func actualizar_medidor():
	var tipo = hud_medidor_inst.id_balas
	hud_medidor_inst.set_nivel_actual(inv_balas.dict_balas[tipo]["cant"])