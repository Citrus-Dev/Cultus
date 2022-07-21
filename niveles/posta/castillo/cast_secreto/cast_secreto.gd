extends Nivel

export(NodePath) onready var segundo_limite = get_node(segundo_limite) as CameraBounds

func cambiar_limites(__):
	segundo_limite.get_new_limits()
