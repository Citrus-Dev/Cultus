class_name ProyectilGaussV2
extends Node2D

const IMPACTO_ESCENA := preload("res://main/particulas/ImpactoGauss.tscn")
const VELOCIDAD_FADE := 2.5

export(NodePath) onready var estela = get_node(estela) as Line2D

var mascara : int
var angle : float
var usador : Jugador
var info_dmg : InfoDmg

func _ready() -> void:
	dibujar_hitscan(angle)
	estela.set_as_toplevel(true)


func _process(delta: float) -> void:
	estela.modulate.a -= delta * VELOCIDAD_FADE
	if estela.modulate.a <= 0:
		call_deferred("free")


func dibujar_hitscan(_dir : float):
	var space = get_world_2d().direct_space_state
	var cast_to := global_position + Vector2.RIGHT.rotated(_dir) * 1000
	var hitscan = space.intersect_ray(
		global_position,
		cast_to,
		[],
		mascara,
		true,
		true
	)
	
	if !hitscan.empty():
		instanciar_efecto(hitscan["position"], hitscan["normal"].angle())
		var collider = hitscan["collider"]
		if collider is Hitbox:
			if !collider.monitorable: return
			var col = collider.owner.name
			
			# Si el dueño de la hitbox es un boss, bajamos el daño un monton
			if (collider.owner.is_in_group("Boss")):
				var menos_dmg = GameState.duplicar_dmg(info_dmg)
				menos_dmg.dmg_cantidad *= 0.3
				collider.recibir_dmg(menos_dmg)
			else:
				collider.recibir_dmg(info_dmg)
	
	var final = hitscan["position"] if !hitscan.empty() else cast_to
	
	estela.points.resize(2)
	estela.add_point(global_position, 0)
	estela.add_point(final, 1)


func instanciar_efecto(pos : Vector2, rot : float):
	var new = IMPACTO_ESCENA.instance()
	get_parent().add_child(new)
	new.rotation = rot
	new.global_position = pos
