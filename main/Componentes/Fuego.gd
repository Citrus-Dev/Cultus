# Agregado como hijo a un personaje, aparece particulas a su alrededor y disminuye la vida periodicamente
class_name Fuego
extends Node

const ES_FUEGO: bool = true
const FRECUENCIA: float = 0.8
const DMG_POR_TICK: int = 18

var vida: float
var timer: float

var dmg: InfoDmg

var target: Personaje
var target_status: Status

func _init(duracion: float = 6.0) -> void:
	vida = duracion
	
	dmg = InfoDmg.new()
	dmg.dmg_cantidad = DMG_POR_TICK
	dmg.dmg_tipo = dmg.DMG_TIPOS.FUEGO


func _ready() -> void:
	target = get_parent()
	if target == null:
		dar_error("nao target")
		return
	
	target_status = target.get_node("Status")
	if target_status == null:
		dar_error("nao status")
		return
	
	# Si se muere el personaje nos borramos
	target_status.connect("morir", self, "dar_error", ["Se murio!!!! chau fuego"])
	
	# Revisar que el personaje no tenga fuego
	# Si ya tiene fuego resetearle el timer y borrar este
	for node in target.get_children():
		if node != self and node.get("ES_FUEGO"):
			node.vida = vida
			dar_error("ya hay fuego chau")
			break
	
	timer = FRECUENCIA


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		target_status.aplicar_dmg(dmg)
		timer = FRECUENCIA
	
	vida -= delta
	if vida <= 0:
		call_deferred("free")


func dar_error(mensaje: String):
	printerr(mensaje)
	call_deferred("free")
