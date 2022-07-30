class_name Revolver
extends Arma

const BALA = preload("res://main/Proyectiles/BalaPistola.tscn")
const TIEMPO_RECARGA := 1.3
const MAX_BALAS := 6
const TIPO_BALAS = "Pistola"
const SONIDO_DISPARO := preload("res://assets/sfx/armas/disparo/Barrett-M82-.50-BMG-Single-Close-Gunshot-A-www.fesliyanstudios.com.mp3")
const SONIDO_RECARGA := preload("res://assets/sfx/armas/recarga/recarga_revolver.wav")

var timer_recarga := Timer.new()
var balas_actual : int = MAX_BALAS

func _init() -> void:
	skin_escena = preload("res://main/Armas/Skins/SkinRevolver.tscn")
	medidor_balas_escena = preload("res://main/UI/BarrasBalas/BarraBalasNoRecarga.tscn")
	damage_info.dmg_cantidad = 25
	damage_info.fuerza_retroceso = 600
	damage_info.dmg_stun = 35
	nombre = "ArmaRevolver"
	
	recoil_visual_duracion = 0.25
	screenshake = 5.0
	cooldown_tiempo = 0.4
	cooldown_tiempo_sec = 0.2
	spread = 2


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
	return
	if timer_recarga.is_stopped() and Input.is_action_just_pressed("recargar"):
		recargar()


func disparar(_origin : Node, _dir : float):
	if timer_recarga.is_stopped() and balas_actual == 0:
		recargar()
	if !puede_disparar(): 
		return
	
	Musica.hacer_sonido(SONIDO_DISPARO, _origin.global_position)
	
	if skin_inst != null:
		skin_inst.animador.stop()
		skin_inst.animador.play("disparar")
	crear_bala(_origin, BALA, _dir, spread)
#	_origin.inv_balas.bajar_balas(1, TIPO_BALAS)
	actualizar_medidor()
	aplicar_screenshake()


func disparar_secundario(_origin : Node, _dir : float):
	disparar(_origin, _dir)


func puede_disparar() -> bool:
	return true
#	return inv_balas.hay_balas(TIPO_BALAS)


func recargar():
	if !hay_balas_reserva() or balas_actual == MAX_BALAS: return
	skin_inst.animador.play("recargar")
	timer_recarga.start()
	Musica.hacer_sonido(SONIDO_RECARGA, skin_inst.global_position)


func terminar_recarga():
	balas_actual = MAX_BALAS
	actualizar_medidor()


func instanciar_medidor(_inv_balas : InvBalas, _hud : CanvasLayer) -> Control:
	if !medidor_balas_escena: return null
	inv_balas = _inv_balas
	hud_medidor_inst = medidor_balas_escena.instance()
	var tipo = hud_medidor_inst.id_balas
	_hud.add_child(hud_medidor_inst)
	hud_medidor_inst.bala_textura = preload("res://assets/ui/balas/hud_bala_icono_revolver.tres")
	hud_medidor_inst.init_barra(MAX_BALAS, balas_actual)
	return hud_medidor_inst


func hay_balas_reserva() -> bool:
	return inv_balas.dict_balas[TIPO_BALAS]["cant"] > balas_actual


func actualizar_medidor():
	var tipo = hud_medidor_inst.id_balas
	hud_medidor_inst.set_cantidad(inv_balas.dict_balas[TIPO_BALAS]["cant"])


