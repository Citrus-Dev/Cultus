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

onready var inv_balas = InvBalas.new()
onready var centro_pantalla = get_viewport_rect().size / 2
onready var usador : Personaje = owner 

func _ready() -> void:
	yield(owner, "ready")
	camara_falsa = get_tree().get_nodes_in_group("CamaraFalsa")[0]
	usador.controlador_armas = self
	yield(get_tree(), "idle_frame")
	
	inicializar_inv_armas()
	agregar_arma(Revolver.new())
	agregar_arma(AR.new())
	agregar_arma(Escopeta.new())
	agregar_arma(Ballesta.new())


func _process(delta: float) -> void:
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
	if !activo: return
	procesar_inventario(event)


func procesar_arma_actual(_delta : float):
	if arma_actual == null: return
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
	
	if arma_actual.esta_en_cooldown(): puede_disparar = false
	
	if puede_disparar:
		puede_disparar = arma_actual.puede_disparar()
	
	if puede_disparar:
		arma_actual.disparar(self, angulo)
		owner.stretcher.stretch(Vector2(0.9, 1.2), arma_actual.recoil_visual_duracion)
		arma_actual.comenzar_cooldown()
		# TODO mover esto al codigo de las armas
		if get_tree().get_nodes_in_group("CamaraReal").size() > 0:
			var cam = get_tree().get_nodes_in_group("CamaraReal")[0]
			cam.shaker.max_offset = Vector2.ONE * arma_actual.screenshake
			cam.aplicar_screenshake(arma_actual.screenshake)


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


func agregar_arma(_arma : Arma):
	var slot = Arma.SLOTS.keys()[_arma.slot]
	_arma.usador = usador
	_arma.damage_info.atacante = usador
	armas[slot] = _arma
	seleccionar_arma(slot)


func seleccionar_arma(_slot : String):
	if armas.has(_slot) and armas[_slot] != null:
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


# Selecciona un arma por numero en la lista en vez de string
func seleccionar_arma_int(_slot : int):
	var slot = Arma.SLOTS.keys()[_slot]
	seleccionar_arma(slot)


# Detecta el input para ver como cambiar las armas con los numeros.
func procesar_inventario(_input : InputEvent):
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
	var slot_arma_actual = arma_actual.slot
	if Input.is_action_just_released("arma_siguiente"):
		seleccionar_arma_int(slot_arma_actual + 1)
		return
	if Input.is_action_just_released("arma_anterior"):
		seleccionar_arma_int(slot_arma_actual - 1)
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

