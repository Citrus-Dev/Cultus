# Caminar de un borde al otro y cada tanto tiempo hacer un ataque (Estado cast)
extends State

const INTERVALO := [1.5, 3.0]

var dir_actual : int
var timer_cast: float

func enter(msg : Dictionary = {}) -> void:
	owner.connect("borde_tocado", self, "tocar_borde")
	cambiar_dir_actual(1)
	
	timer_cast = rand_range(INTERVALO[0], INTERVALO[1])


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	owner.mirar_al_jugador()
	timer_cast -= delta
	if timer_cast <= 0:
		owner.fsm.transition_to("Cast")


func physics_process(delta : float) -> void:
	owner.animador.play("walk")


func exit() -> void:
	owner.disconnect("borde_tocado", self, "tocar_borde")


func tocar_borde(_borde):
	cambiar_dir_actual(-1 if dir_actual == 1 else 1)


func cambiar_dir_actual(_dir : int = 1):
	dir_actual = _dir
	owner.set_dir(dir_actual)
	owner.input.x = dir_actual
