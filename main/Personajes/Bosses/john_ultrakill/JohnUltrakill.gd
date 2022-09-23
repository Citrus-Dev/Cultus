class_name JohnUltrakill
extends Personaje

signal terminado_de_tirar_monedas

const MONEDA_ESCENA := preload("res://main/Personajes/Bosses/john_ultrakill/Monedita.tscn")

const FUERZA_TIRAR_MONEDA := Vector2(75, -300)
const MAX_MONEDAS := 3
const MAX_COOLDOWN_MONEDAS := 0.3

export(NodePath) onready var barra_hp = get_node(barra_hp) as BarraHPBoss
export(NodePath) onready var controlador_armas = get_node(controlador_armas) as ControladorArmasNPC

var cooldown_monedas: float
var monedas_tiradas: int
var tirando_monedas: bool
var monedas_disparadas: bool
var ultima_moneda_tirada: Monedita







func _process(delta):
	tirar_monedas(delta)



func tirar_monedas(delta: float):

	# Tiramos todas las monedas?
	if monedas_tiradas > MAX_MONEDAS:
		return
	
	# Estamos en cooldown?
	if (cooldown_monedas > 0):
		# Bajar el cooldown y no hacer nada
		cooldown_monedas -= delta
		return
	
	crear_moneda(Vector2(FUERZA_TIRAR_MONEDA.x * dir, FUERZA_TIRAR_MONEDA.y))
	
	if monedas_tiradas > MAX_MONEDAS:
		emit_signal("terminado_de_tirar_monedas")
		monedas_disparadas = false
		cooldown_monedas = 0
		
		# Dispararle a la ultima moneda que tiraste
		monedas_disparadas = true
		hacer_disparo_hitscan(global_position, ultima_moneda_tirada.global_position, null)




func crear_moneda(dir: Vector2):
	var inst: Monedita = MONEDA_ESCENA.instance()
	get_tree().root.add_child(inst)
	inst.global_position = controlador_armas.global_position
	inst.velocity = dir
	
	monedas_tiradas += 1
	ultima_moneda_tirada = inst
	cooldown_monedas = MAX_COOLDOWN_MONEDAS
	inst.connect("tree_exited", self, "moneda_destruida")




func moneda_destruida():
	monedas_tiradas -= 1




func hacer_disparo_hitscan(inicio: Vector2, final: Vector2, dmg: InfoDmg):
	var linea = Tracer.new(inicio, final, 0.5)
	linea.width = 2

	get_tree().root.add_child(linea)