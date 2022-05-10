extends State

var dir_actual : int

func enter(msg : Dictionary = {}) -> void:
	owner.connect("objetivo_encontrado", self, "alertar")
	owner.connect("borde_tocado", self, "tocar_borde")
	owner.max_velocidad_horizontal = 35
	cambiar_dir_actual()


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.disconnect("objetivo_encontrado", self, "alertar")
	owner.disconnect("borde_tocado", self, "tocar_borde")
	owner.valor_default("max_velocidad_horizontal")


func alertar():
	if !owner.ciego:
		_state_machine.transition_to("Perseguir")


func tocar_borde(_borde):
	cambiar_dir_actual(-1 if dir_actual == 1 else 1)


func cambiar_dir_actual(_dir : int = 1):
	dir_actual = _dir
	owner.set_dir(dir_actual)
	owner.input.x = dir_actual
