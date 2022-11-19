class_name Arma
extends Reference

signal empezado_a_apuntar
signal dejado_de_apuntar

var skin_escena = preload("res://main/Armas/Skins/SkinArma.tscn")
var textura_hud_selec: Texture
var medidor_balas_escena
var ui_escena
var casquillo_escena : PackedScene

signal disparado

enum SLOTS {
	PISTOLA,
	RIFLE,
	ESCOPETA,
	BALLESTA,
	BAZUCA
}

var nombre := "arma"
var damage_info = InfoDmg.new()
var cooldown_tiempo : float = 0.8
var cooldown_tiempo_sec : float = 1
var automatica : bool
var spread : float
var slot : int
var dir_mirar : int
var usador : Personaje
var screenshake : float # Fuerza de screenshake USAR POCO
# maxima distancia que se puede desplazar la camara por el screenshake de esta arma USAR POCO
var screenshake_max_offset : Vector2

var cooldown_actual : float
var cooldown_actual_sec : float
# Duracion de la animacion de recoil (Cuando la sprite del jugador se estira cuando disparas)
var recoil_visual_duracion : float = 0.3 
var skin_inst : SkinArma
var hud_medidor_inst : HudMedidorBalas
var inv_balas : InvBalas
var cont 
var ia_largo_rafaga : float

var variantes := [
	"NORMAL"
]
var variante_actual : int

func _init() -> void:
	damage_info.dmg_cantidad = 1
	damage_info.dmg_tipo = InfoDmg.DMG_TIPOS.BALA
	damage_info.atacante = usador


func equipar(_controlador):
	pass


func desequipar(_controlador):
	pass


func procesar_arma(_delta : float):
	pass


func reducir_cooldown(_delta : float):
	if esta_en_cooldown():
		cooldown_actual -= _delta


func reducir_cooldown_sec(_delta : float):
	if esta_en_cooldown_sec():
		cooldown_actual_sec -= _delta


func disparar(_origin : Node, _dir : float):
	pass


func disparar_secundario(_origin : Node, _dir : float):
	pass


func crear_bala(_origin : Node, _preload_bala : PackedScene, _angulo : float, _spread : float = 0.0):
	var bala = _preload_bala.instance()
	
	# Si el usador es un jugador hacemos que colisione con el mundo y hitbox de npc,
	# sino con hitbox del jugador
	if usador.is_in_group("Jugador"):
		bala.collision_mask = 33
	else:
		bala.collision_mask = 17
		damage_info.atacante = usador
	
	bala.rotation = _angulo
	bala.info_dmg = damage_info
	bala.z_index = -1
	if _spread != 0.0:
		var spread_rad = deg2rad(_spread)
		bala.rotation += rand_range(-spread_rad, spread_rad)
	
	_origin.add_child(bala)


func esta_en_cooldown() -> bool:
	return cooldown_actual > 0


func esta_en_cooldown_sec() -> bool:
	return cooldown_actual_sec > 0


func comenzar_cooldown():
	cooldown_actual = cooldown_tiempo


func comenzar_cooldown_sec():
	cooldown_actual_sec = cooldown_tiempo_sec


# Gira la skin del arma hacia la direccion del mouse
func apuntar(_angulo : float):
	if skin_inst == null: return
	var angl = _angulo + deg2rad(90)
	var signed = 1 if angl > 0 and angl <= 3.2 else -1
	skin_inst.rotation = _angulo
	skin_inst.scale.y = signed
	dir_mirar = signed


func eyectar_casquillo(_angulo : float):
	if skin_inst == null or casquillo_escena == null: 
		return
	
	var emisor = skin_inst.pos_casquillos as Position2D
	var casq = casquillo_escena.instance() as Casquillo
	casq.fuerza = 350
	casq.vel_dir = Vector2.RIGHT.rotated(emisor.rotation * dir_mirar + _angulo)
	casq.flip = dir_mirar
	skin_inst.get_parent().add_child(casq)


func instanciar_skin(_parent : Node2D, _skin_escena = skin_escena):
	var inst = _skin_escena.instance()
	_parent.add_child(inst)
	skin_inst = inst


func instanciar_medidor(_inv_balas : InvBalas, _hud : CanvasLayer) -> Control:
	if !medidor_balas_escena: return null
	inv_balas = _inv_balas
	hud_medidor_inst = medidor_balas_escena.instance()
	var tipo = hud_medidor_inst.id_balas
	_hud.add_child(hud_medidor_inst)
	hud_medidor_inst.init_barra(_inv_balas.dict_balas[tipo]["max"], _inv_balas.dict_balas[tipo]["cant"])
	return hud_medidor_inst


func actualizar_medidor():
	pass


func puede_disparar() -> bool:
	return true


func borrar_medidor():
	if !hud_medidor_inst: return null
	hud_medidor_inst.call_deferred("free")


func borrar_skin():
	if skin_inst == null: return
	skin_inst.call_deferred("free")
	skin_inst = null


func aplicar_screenshake():
	if usador.get_tree().get_nodes_in_group("CamaraReal").size() > 0:
		var cam = usador.get_tree().get_nodes_in_group("CamaraReal")[0]
		cam.shaker.max_offset = Vector2.ONE * screenshake
		cam.aplicar_screenshake(screenshake)


func ciclar_variante():
	var variante_nueva
	var unlock = tomar_variantes_desbloqueadas()
	var disponible : bool
	for n in variantes.size():
		variante_nueva = wrapi(variante_actual + 1 + n, 0, variantes.size())
		if variante_nueva in unlock or variante_nueva == 0: 
			disponible = true
			break
	
	if disponible and variante_actual != variante_nueva:
		cambiar_variante_actual(variante_nueva)


func cambiar_variante_actual(nueva : int):
	variante_actual = nueva
	var func_cambio = "cambio_variante_" + variantes[nueva] 
	if has_method(func_cambio):
		call(func_cambio)


func tomar_variantes_desbloqueadas() -> Array:
	if TransicionesDePantalla.inv_variantes.has(nombre):
		return TransicionesDePantalla.inv_variantes[nombre]
	else: return []


func ai_empezar_a_apuntar():
	emit_signal("empezado_a_apuntar")

func ai_terminar_de_apuntar():
	emit_signal("dejado_de_apuntar")





