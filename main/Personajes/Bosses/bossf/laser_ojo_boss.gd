class_name LaserOjoBoss
extends Node2D

const DMG: int = 15
const TIPO: int = 4 # InfoDmg.DMG_TIPOS.FUEGO
const RETROCESO: int = 150

export(NodePath) onready var raycast = get_node(raycast) as RayCast2D
export(NodePath) onready var raycast_dmg = get_node(raycast_dmg) as RayCast2D
export(NodePath) onready var linea = get_node(linea) as Line2D

var activo: bool

func _process(delta):
	raycast.force_raycast_update()
	var col = global_position - raycast.get_collision_point()
	linea.set_point_position(1, -col)
	linea.global_position = global_position
	
	raycast_dmg.force_raycast_update()
	if activo and raycast_dmg.is_colliding():
		var jug_hitbox: Hitbox = raycast_dmg.get_collider()
		
		if jug_hitbox.desactivado: return
		
		var dmg: InfoDmg = InfoDmg.new()
		dmg.atacante = owner
		dmg.dmg_cantidad = DMG
		dmg.dmg_tipo = TIPO
		dmg.fuerza_retroceso = RETROCESO
		
		jug_hitbox.recibir_dmg( dmg )




func set_activo( toggle: bool ):
	activo = toggle
	raycast.enabled = activo
	raycast_dmg.enabled = activo












