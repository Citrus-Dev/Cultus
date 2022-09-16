extends Nivel

export(NodePath) onready var segundo_limite = get_node(segundo_limite) as CameraBounds

func cambiar_limites(__):
	segundo_limite.get_new_limits()


func nadie_te_va_a_creer(__):
	ControladorUi.mensaje_ui("NADIE TE VA A CREER", 2.5)
	yield(get_tree().create_timer(0.3), "timeout")
	ControladorUi.mensaje_ui("NADIE TE VA A CREER", 2.5)
	yield(get_tree().create_timer(0.3), "timeout")
	ControladorUi.mensaje_ui("NADIE TE VA A CREER", 2.5)
	yield(get_tree().create_timer(0.3), "timeout")
	ControladorUi.mensaje_ui("NADIE TE VA A CREER", 2.5)
	yield(get_tree().create_timer(0.3), "timeout")
	ControladorUi.mensaje_ui("NADIE TE VA A CREER", 2.5)
