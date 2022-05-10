class_name Escopeta
extends Arma

const BALA = preload("res://main/Proyectiles/BalaEscopeta.tscn")
var perdigones : int = 5

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinShotgun.tscn")
	casquillo_escena = preload("res://main/Efectos/Casquillos/CasquilloEscopeta.tscn")
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasNoRecarga.tscn")
	damage_info.dmg_cantidad = 12
	damage_info.fuerza_retroceso = 400
	damage_info.dmg_stun = 25
	
	slot = SLOTS.ESCOPETA
	automatica = false
	cooldown_tiempo = 0.65
	recoil_visual_duracion = 0.4
	spread = 4
	screenshake = 5.0


func disparar(_origin : Node, _dir : float):
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	
	eyectar_casquillo(_dir)
	_origin.inv_balas.bajar_balas(1, "Escopeta")
	actualizar_medidor()
	for i in perdigones:
		var angle = ((i - perdigones / 2) * deg2rad(spread) * PI / perdigones) + _dir 
		crear_bala(_origin, BALA, angle)
	
	usador.aplicar_knockback(250, -Vector2.RIGHT.rotated(_dir))


func puede_disparar() -> bool:
	return inv_balas.hay_balas("Escopeta")


func instanciar_medidor(_inv_balas : InvBalas, _hud : CanvasLayer) -> Control:
	if !medidor_balas_escena: return null
	inv_balas = _inv_balas
	hud_medidor_inst = medidor_balas_escena.instance()
	hud_medidor_inst.id_balas = "Escopeta"
	hud_medidor_inst.bala_textura = load("res://assets/ui/balas/hud_bala_icono_escopeta.tres")
	var tipo = hud_medidor_inst.id_balas
	_hud.add_child(hud_medidor_inst)
	hud_medidor_inst.init_barra(_inv_balas.dict_balas[tipo]["max"], _inv_balas.dict_balas[tipo]["cant"])
	return hud_medidor_inst


func actualizar_medidor():
	var tipo = hud_medidor_inst.id_balas
	hud_medidor_inst.set_cantidad(inv_balas.dict_balas[tipo]["cant"])
