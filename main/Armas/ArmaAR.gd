class_name AR
extends Arma

const MAX_BALAS = 30 # Tamaño cargador
const TIPO_BALAS = "Rifle"
const TIEMPO_RECARGA = 1.2
const BALA = preload("res://main/Proyectiles/BalaAR.tscn")
const SKIN_FLASH_ESCENA = preload("res://main/Armas/Skins/SkinARFlash.tscn")
const PROY_GRANADA_ESCENA = preload("res://main/Proyectiles/GranadaAR.tscn")
const PROY_GRANADA_FLASH_ESCENA = preload("res://main/Proyectiles/GranadaARFlash.tscn")

var balas_actual : int = MAX_BALAS
var timer_recarga := Timer.new()

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinAR.tscn")
	casquillo_escena = preload("res://main/Efectos/Casquillos/CasquilloBase.tscn")
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasRevolver.tscn")
	damage_info.dmg_cantidad = 15
	damage_info.fuerza_retroceso = 400
	damage_info.dmg_stun = 15
	
	slot = SLOTS.RIFLE
	automatica = true
	cooldown_tiempo = 0.1
	recoil_visual_duracion = 0.2
	spread = 5
	screenshake = 2.5
	nombre = "ArmaAR"
	
	variantes = [
	"NORMAL",
	"FLASH"
	]


func equipar(_controlador):
	actualizar_medidor()
	timer_recarga = Timer.new()
	timer_recarga.one_shot = true
	timer_recarga.wait_time = TIEMPO_RECARGA
	_controlador.add_child(timer_recarga)
	timer_recarga.connect("timeout", self, "terminar_recarga")


func desequipar(_controlador):
	_controlador.remove_child(timer_recarga)
	timer_recarga.disconnect("timeout", self, "terminar_recarga")


func procesar_arma(_delta : float):
	if timer_recarga.is_stopped() and Input.is_action_just_pressed("recargar"):
		recargar()


func disparar(_origin : Node, _dir : float):
	if !puede_disparar(): 
		return
	elif timer_recarga.is_stopped() and balas_actual == 0:
		recargar()
	
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	eyectar_casquillo(_dir)
	crear_bala(_origin, BALA, _dir, spread)
	_origin.inv_balas.bajar_balas(1, TIPO_BALAS)
	balas_actual -= 1
	actualizar_medidor()
	aplicar_screenshake()


func disparar_secundario(_origin : Node, _dir : float):
	if variantes[variante_actual] == "NORMAL":
		var gren = PROY_GRANADA_ESCENA.instance()
		gren.vel_entrada = Vector2.RIGHT.rotated(_dir) * 600
		gren.z_index = -1
		_origin.add_child(gren)
	if variantes[variante_actual] == "FLASH":
		var gren = PROY_GRANADA_FLASH_ESCENA.instance()
		gren.vel_entrada = Vector2.RIGHT.rotated(_dir) * 600
		gren.z_index = -1
		_origin.add_child(gren)


func puede_disparar() -> bool:
	return balas_actual > 0 and timer_recarga.is_stopped() and inv_balas.hay_balas(TIPO_BALAS)


func recargar():
	if !hay_balas_reserva() or balas_actual == MAX_BALAS: return
	skin_inst.animador.play("recargar")
	timer_recarga.start()


func terminar_recarga():
	balas_actual = MAX_BALAS
	actualizar_medidor()


func instanciar_medidor(_inv_balas : InvBalas, _hud : CanvasLayer):
	if !medidor_balas_escena: return null
	inv_balas = _inv_balas
	hud_medidor_inst = medidor_balas_escena.instance()
	hud_medidor_inst.id_balas = TIPO_BALAS
	_hud.add_child(hud_medidor_inst)
	hud_medidor_inst.bala_textura = preload("res://assets/ui/balas/hud_bala_icono_rifle.tres")
	hud_medidor_inst.init_barra(MAX_BALAS, balas_actual)


func hay_balas_reserva() -> bool:
	return inv_balas.dict_balas[TIPO_BALAS]["cant"] > balas_actual


func actualizar_medidor():
	var tipo = hud_medidor_inst.id_balas
	hud_medidor_inst.set_cantidad(min(balas_actual, inv_balas.dict_balas[tipo]["cant"]))
	var reserva = max(0, inv_balas.dict_balas[tipo]["cant"] - balas_actual)
	hud_medidor_inst.set_balas_reserva(reserva)


func cambio_variante_NORMAL():
	borrar_skin()
	instanciar_skin(cont)


func cambio_variante_FLASH():
	borrar_skin()
	instanciar_skin(cont, SKIN_FLASH_ESCENA)
