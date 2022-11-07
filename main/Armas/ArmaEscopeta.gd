class_name Escopeta
extends Arma

const TIEMPO_DELAY_SONIDO_ESCOPETA := 0.2

const BALA = preload("res://main/Proyectiles/BalaEscopeta.tscn")
const BALA_FLAK = preload("res://main/Proyectiles/BalaFlak.tscn")
const SKIN_ALT = preload("res://main/Armas/Skins/SkinShotgun_alt.tscn")
const SONIDO_DISPARO := preload("res://assets/sfx/armas/disparo/Beefy-12-Gauge-Pump-Action-Shotgun-Close-Gunshot-D-www.fesliyanstudios.com-www.fesliyanstudios.com.mp3")
const SONIDO_CHCK_CHCK := preload("res://assets/sfx/armas/recarga/mixkit-shotgun-pump-1659.wav")

const COSTO_BALAS_FLAK := 3
const COSTO_BALAS_SUPER := 3

var perdigones : int = 5
var perdigones_flak : int = 5
var snd_timer_chck_chk : float

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinShotgun.tscn")
	casquillo_escena = preload("res://main/Efectos/Casquillos/CasquilloEscopeta.tscn")
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasNoRecarga.tscn")
	damage_info.dmg_cantidad = 16
	damage_info.fuerza_retroceso = 400
	damage_info.dmg_stun = 25
	nombre = "ArmaEscopeta"
	
	slot = SLOTS.ESCOPETA
	automatica = false
	cooldown_tiempo = 0.65
	recoil_visual_duracion = 0.4
	spread = 4
	screenshake = 5.0
	
	variantes = [
	"FLAK",
	"SUPER"
	]


func procesar_arma(_delta : float):
	if snd_timer_chck_chk > 0:
		snd_timer_chck_chk -= _delta
		if snd_timer_chck_chk <= 0:
			Musica.hacer_sonido(SONIDO_CHCK_CHCK, skin_inst.global_position)


func disparar(_origin : Node, _dir : float):
	if !puede_disparar(): 
		return
	
	Musica.hacer_sonido(SONIDO_DISPARO, _origin.global_position)
	snd_timer_chck_chk = TIEMPO_DELAY_SONIDO_ESCOPETA
	
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	
	eyectar_casquillo(_dir)
	_origin.inv_balas.bajar_balas(1, "Escopeta")
	actualizar_medidor()
	for i in perdigones:
		var angle = ((i - perdigones / 2) * deg2rad(spread) * PI / perdigones) + _dir 
		crear_bala(_origin, BALA, angle)
	
	usador.aplicar_knockback(190, -Vector2.RIGHT.rotated(_dir))
	aplicar_screenshake()


func disparar_secundario(_origin : Node, _dir : float):
	if !puede_disparar_sec(): 
		return
	if variantes[variante_actual] == "FLAK" and puede_disparar_flak():
		disparo_alt_flak(_origin, _dir)
	if variantes[variante_actual] == "SUPER" and puede_disparar_super():
		disparo_alt_super(_origin, _dir)


func disparo_alt_flak(_origin : Node, _dir : float):
	for i in perdigones_flak:
		var angle = ((i - perdigones / 2) * deg2rad(spread) * PI / perdigones) + _dir 
		
		var bala = BALA_FLAK.instance()
		bala.vel_entrada = Vector2.RIGHT.rotated(angle) * 600
		_origin.add_child(bala)
	
	_origin.inv_balas.bajar_balas(COSTO_BALAS_FLAK, "Escopeta")
	actualizar_medidor()
	
	usador.aplicar_knockback(100, -Vector2.RIGHT.rotated(_dir))
	aplicar_screenshake()


func disparo_alt_super(_origin : Node, _dir : float):
	for i in perdigones * 2:
		var angle = ((i - perdigones / 2) * deg2rad(spread) * PI / perdigones) + _dir 
		crear_bala(_origin, BALA, angle)
	
	_origin.inv_balas.bajar_balas(COSTO_BALAS_SUPER, "Escopeta")
	actualizar_medidor()
	
	usador.aplicar_knockback(250, -Vector2.RIGHT.rotated(_dir))
	aplicar_screenshake_mas_cebado()


func puede_disparar() -> bool:
	return inv_balas.hay_balas("Escopeta")


func puede_disparar_flak() -> bool:
	return inv_balas.hay_balas("Escopeta", COSTO_BALAS_FLAK - 1)


func puede_disparar_super() -> bool:
	return inv_balas.hay_balas("Escopeta", COSTO_BALAS_SUPER - 1)


func puede_disparar_sec() -> bool:
	return true


func cambio_variante_FLAK():
	print("FLAK")
	borrar_skin()
	instanciar_skin(cont)


func cambio_variante_SUPER():
	print("SUPER")
	borrar_skin()
	instanciar_skin(cont, SKIN_ALT)


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


func aplicar_screenshake_mas_cebado():
	if usador.get_tree().get_nodes_in_group("CamaraReal").size() > 0:
		var cam = usador.get_tree().get_nodes_in_group("CamaraReal")[0]
		cam.shaker.max_offset = Vector2.ONE * screenshake * 1.6
		cam.aplicar_screenshake(screenshake)


func instanciar_skin(_parent : Node2D, _skin_escena = skin_escena):
	match variantes[variante_actual]:
		"FLAK":
			_skin_escena = skin_escena
		"SUPER":
			_skin_escena = SKIN_ALT
	var inst = _skin_escena.instance()
	_parent.add_child(inst)
	skin_inst = inst

