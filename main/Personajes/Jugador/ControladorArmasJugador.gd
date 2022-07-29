class_name ControladorArmasJugador
extends Node2D

var angulo : float
var distancia : float
var mouse_pos : Vector2

var armas : Dictionary = {}
var arma_actual : Arma
var slot_actual : String
var camara_falsa : Camera2D
var min_dist : float = 100.0
var max_dist : float = 250.0

var activo : bool = true setget set_activo

onready var tabla_armas := Armas.new()
onready var inv_balas = InvBalas.new()
onready var centro_pantalla = get_viewport_rect().size / 2
onready var usador : Personaje = owner 

func _init():
	add_to_group("ArmasJugador")


func _ready() -> void:
	yield(owner, "ready")
	camara_falsa = get_tree().get_nodes_in_group("CamaraFalsa")[0]
	usador.controlador_armas = self
	yield(get_tree(), "idle_frame")
	
	if TransicionesDePantalla.inv_armas.empty():
		inicializar_inv_armas()
	else:
		inicializar_inv_armas()
		var lista = TransicionesDePantalla.inv_armas
		for i in lista:
			if lista[i] == null: continue
			agregar_arma_string(lista[i])


func _process(delta: float) -> void:
	if inv_vacio(): return
	if arma_actual != null and activo:
		arma_actual.apuntar(angulo)
	procesar_inventario_ruedita()


func _physics_process(delta: float) -> void:
	if !activo: return
	calcular_angulo()
	calcular_distancia()
	update()
	procesar_arma_actual(delta)


func _draw() -> void:
	return
	draw_line(Vector2.ZERO, mouse_pos, Color.green, 1.0, true)
	draw_circle(Vector2.ZERO, 1.0, Color.yellow)
	draw_circle(mouse_pos, 1.0, Color.yellow)


func _unhandled_input(event: InputEvent) -> void:
	if !activo or inv_vacio(): return
	procesar_inventario(event)


func procesar_arma_actual(_delta : float):
	if arma_actual == null or !activo: return
	arma_actual.procesar_arma(_delta)
	
	arma_actual.reducir_cooldown(_delta)
	arma_actual.reducir_cooldown_sec(_delta)
	
	if Input.is_action_pressed("disparo_secundario") and !arma_actual.esta_en_cooldown_sec():
		arma_actual.disparar_secundario(self, angulo)
		arma_actual.comenzar_cooldown_sec()
		return
	
	var puede_disparar : bool
	if arma_actual.automatica:
		puede_disparar = Input.is_action_pressed("disparo_primario")
	else:
		puede_disparar = Input.is_action_just_pressed("disparo_primario")
	
	if Input.is_action_just_pressed("ciclar_var"):
		arma_actual.ciclar_variante()
	
	if arma_actual.esta_en_cooldown(): puede_disparar = false
	
	if puede_disparar:
		arma_actual.disparar(self, angulo)
		owner.stretcher.stretch(Vector2(0.9, 1.2), arma_actual.recoil_visual_duracion)
		arma_actual.comenzar_cooldown()


# Calcula la direccion a la que apuntas con el mouse.
func calcular_angulo():
	mouse_pos = get_local_mouse_position()
	var dir = mouse_pos
	angulo = dir.angle()
	calcular_dir_mirada()


# Calcula la distancia entre el mouse y el centro de la pantalla.
func calcular_distancia():
	var mouse_pos_viewport = get_viewport().get_mouse_position()
	distancia = abs((mouse_pos_viewport - centro_pantalla).length()) - min_dist
	distancia = clamp(distancia, 0, max_dist)
	camara_falsa.offset = (Vector2.RIGHT * distancia).rotated(angulo)


# Calcula si el jugador esta viendo para la izquierda o la derecha.
func calcular_dir_mirada():
	# Si esta entre 0 y 3.2 es a la derecha, sino a la izquierda
	var angl = angulo + deg2rad(90)
	var signed = 1 if angl > 0 and angl <= 3.2 else -1
	owner.dir = signed


func inicializar_inv_armas():
	var slots = Arma.SLOTS.keys()
	for sl in slots:
		armas[sl] = null


# NO USAR
# USAR agregar_arma_string
func agregar_arma(_arma : Arma):
	var slot = tomar_slot_de_arma(_arma)
	_arma.usador = usador
	_arma.damage_info.atacante = usador
	armas[slot] = _arma
	seleccionar_arma(slot)
#	TransicionesDePantalla.inv_armas = armas


func agregar_arma_string(dir : String):
	var good_dir = tabla_armas.armas_lista[dir]
	var arma_inst = Reference.new()
	arma_inst.set_script(load(good_dir))
	arma_inst.cont = self
	if arma_inst is Arma:
		agregar_arma(arma_inst)
		var slot = tomar_slot_de_arma(arma_inst)
		TransicionesDePantalla.inv_armas[slot] = dir


func tomar_slot_de_arma(arma : Arma) -> String:
	var slot = Arma.SLOTS.keys()[arma.slot]
	return slot


func seleccionar_arma(_slot : String):
	if !tiene_slot_vacio(_slot):
		if arma_actual: 
			arma_actual.desequipar(self)
			arma_actual.borrar_medidor()
		
		slot_actual = _slot
		if arma_actual != null:
			arma_actual.borrar_skin()
		arma_actual = armas[_slot]
		arma_actual.instanciar_skin(self)
		
		var hud = get_tree().get_nodes_in_group("HUD")[0]
		var med = arma_actual.instanciar_medidor(inv_balas, hud)
		ControladorUi.medidor_balas = med
		
		arma_actual.equipar(self)


func tiene_slot_vacio(_slot : String) -> bool:
	return not (armas.has(_slot) and armas[_slot] != null)


# Selecciona un arma por numero en la lista en vez de string
func seleccionar_arma_int(_slot : int, suma : int):
	var rango_slots = Arma.SLOTS.keys().size()
	
	var contador_iter : int = rango_slots
	var nuevo_slot : int = _slot
	while contador_iter > 0:
		nuevo_slot = wrapi(nuevo_slot + suma, 0, rango_slots)
		var slot = Arma.SLOTS.keys()[nuevo_slot]
		if !tiene_slot_vacio(slot):
			seleccionar_arma(slot)
			break
		else:
			contador_iter -= 1


# Detecta el input para ver como cambiar las armas con los numeros.
func procesar_inventario(_input : InputEvent):
	if !activo or inv_vacio(): return
	if _input is InputEventKey:
		var just_pressed = _input.is_pressed() and not _input.is_echo()
		if !just_pressed: return
		
		var sc : int = _input.scancode
		# Los numeros del 1 al 5 son desde el 49 hasta el 53
		if sc >= 49 and sc <= 53:
			sc -= 49
			match sc:
				0:	# Pistola
					seleccionar_arma("PISTOLA")
				1:	# Rifle de asalto
					seleccionar_arma("RIFLE")
				2:	# Escopeta
					seleccionar_arma("ESCOPETA")
				3:	# Ballesta
					seleccionar_arma("BALLESTA")
				4:	# Bazuca
					seleccionar_arma("BAZUCA")


# Procesa cambiar las armas con la ruedita
func procesar_inventario_ruedita():
	if !activo or inv_vacio(): return
	var slot_arma_actual = arma_actual.slot
	if Input.is_action_just_released("arma_siguiente"):
		seleccionar_arma_int(slot_arma_actual, 1)
		return
	if Input.is_action_just_released("arma_anterior"):
		seleccionar_arma_int(slot_arma_actual, -1)
		return


func set_activo(_bool : bool):
	activo = _bool
	
	if !_bool:
		camara_falsa.offset = Vector2.ZERO
	
	if arma_actual and arma_actual.skin_inst:
		var skin : SkinArma = arma_actual.skin_inst
		skin.visible = _bool


func info_debug():
	DebugDraw.set_text("dir", rad2deg(angulo))
	DebugDraw.set_text("raw_dir", angulo)
	DebugDraw.set_text("mousepos", mouse_pos)
	DebugDraw.set_text("centro_pantalla", centro_pantalla)
	DebugDraw.set_text("dist", distancia)


func inv_vacio() -> bool:
	var result := true
	for slot in armas:
		if armas[slot] != null: 
			result = false
			break
	return result
