extends State

var timer := 0.8

func enter(msg := {}):
	owner.animador.play("hurt")


func process(delta : float) -> void:
	if timer <= 0: return
	
	timer -= delta
	if timer <= 0:
		terminar_de_morir()


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 


func terminar_de_morir():
	owner.instanciar_gibs()
	owner.cambiar_visibilidad(false)
