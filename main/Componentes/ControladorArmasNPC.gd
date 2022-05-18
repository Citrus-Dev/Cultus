# Igual que el controlador de armas para el jugador pero con menos funciones que no necesita
# Hay codigo repetido porque soy un inutil
class_name ControladorArmasNPC
extends Node2D

signal termino_de_disparar

# Angulo default al que gira el arma si no hay objetivos
const DEFAULT_ANGULO := 50.0

export(String) var nombre_arma

var angulo : float
var arma_actual : Arma
var activo : bool = true setget set_activo
var target_obj : Node2D
var input_disparar : int

onready var usador : Personaje = owner
onready var tabla_armas := Armas.new()

func _ready() -> void:
	if nombre_arma:
		equipar_arma(nombre_arma)


func _process(delta: float) -> void:
	if arma_actual != null and activo:
		arma_actual.apuntar(angulo)


func _physics_process(delta: float) -> void:
	if !activo: return
	calcular_angulo()
	update()
	procesar_arma_actual(delta)


func equipar_arma(_nombre : String):
	var carga = tabla_armas.tomar_obj_lista(_nombre)
	if carga == null:
		return
	
	if arma_actual != null:
		arma_actual.borrar_skin()
	
	var ref = Reference.new()
	ref.set_script(carga)
	arma_actual = ref
	arma_actual.usador = owner
	
	arma_actual.instanciar_skin(self)


func calcular_angulo():
	if !is_instance_valid(target_obj):
		angulo = deg2rad(DEFAULT_ANGULO + (90.0 if usador.dir == -1 else 0.0))
	else:
		var dir = target_obj.global_position - owner.global_position
		angulo = dir.angle()
	calcular_dir_mirada()


func calcular_dir_mirada():
	# Si esta entre 0 y 3.2 es a la derecha, sino a la izquierda
	var angl = angulo + deg2rad(90)
	var signed = 1 if angl > 0 and angl <= 3.2 else -1
	usador.dir = signed


func procesar_arma_actual(_delta : float):
	if arma_actual == null: return
	
	arma_actual.reducir_cooldown(_delta)
	
	var puede_disparar : bool = true if input_disparar > 0 else false
	
	if arma_actual.esta_en_cooldown(): puede_disparar = false
	
	if puede_disparar:
		input_disparar -= 1
		arma_actual.disparar(self, angulo)
#		owner.stretcher.stretch(Vector2(0.9, 1.2), arma_actual.recoil_visual_duracion)
		arma_actual.comenzar_cooldown()
		if input_disparar <= 0:
			usador.disparando = false
			emit_signal("termino_de_disparar")


func set_activo(_bool : bool):
	activo = _bool
	
	if arma_actual and arma_actual.skin_inst:
		var skin : SkinArma = arma_actual.skin_inst
		skin.visible = _bool
