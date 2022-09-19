class_name JohnUltrakill
extends Personaje

signal terminado_de_tirar_monedas

const MONEDA_ESCENA := preload("res://main/Personajes/Bosses/john_ultrakill/Monedita.tscn")

const FUERZA_TIRAR_MONEDA := Vector2(75, -150)
const MAX_MONEDAS := 3
const MAX_COOLDOWN_MONEDAS := 0.6

export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var controlador_armas = get_node(controlador_armas) as ControladorArmasNPC

var cooldown_monedas: float
var monedas_tiradas: int
var tirando_monedas: bool







func _process(delta):
	tirar_monedas(delta)



func tirar_monedas(delta: float):
	if monedas_tiradas > MAX_MONEDAS:
		return
	
	if (cooldown_monedas > 0):
		cooldown_monedas -= delta
		return
	
	crear_moneda(Vector2(FUERZA_TIRAR_MONEDA.x * dir, FUERZA_TIRAR_MONEDA.y))
	
	if monedas_tiradas > MAX_MONEDAS:
		emit_signal("terminado_de_tirar_monedas")


func crear_moneda(dir: Vector2):
	var inst: Monedita = MONEDA_ESCENA.instance()
	get_tree().root.add_child(inst)
	inst.global_position = controlador_armas.global_position
	inst.velocity = dir
	
	monedas_tiradas += 1
	cooldown_monedas = MAX_COOLDOWN_MONEDAS
	inst.connect("tree_exited", self, "moneda_destruida")


func moneda_destruida():
	monedas_tiradas -= 1

