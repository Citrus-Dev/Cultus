extends Nivel

export(NodePath) onready var limites_camara_boss = get_node(limites_camara_boss) as CameraBounds

var focus_cam_boss : bool

func alternar_limites_boss(toggle : bool):
	focus_cam_boss = toggle
	if focus_cam_boss:
		cambiar_limites_camara(limites_camara_boss)
	else:
		cambiar_limites_camara(primer_limite_camara_obj)
