class_name Flecha
extends ProyectilBase

var colisionados: Array # Guardar enemigos que ya se atravesaron en esta lista

func cosas_de_proyectil(delta: float) -> void:
	var pos_frame_anterior = global_position
	
	global_position += velocity * delta
	estela.add_point(global_position)
	
	var space_state = get_world_2d().direct_space_state
	var res = space_state.intersect_ray(
		pos_frame_anterior,
		global_position,
		[self] + colisionados,
		collision_mask,
		true,
		true
	)
	
	if !res.empty():
		
		var collider = res["collider"]
		hit(collider)
		
		if collider is Hitbox:
			colisionados.append(collider)
			if !collider.monitorable: return
			var col = collider.owner.name
			collider.recibir_dmg(info_dmg)
		else:
			global_position = res["position"]
			if efecto:
				instanciar_efecto(res["position"], res["normal"].angle(), res["collider"])
			call_deferred("free")
	
	if estela.points.size() > estela.numero_de_segmentos + 1:
		estela.remove_point(0)
