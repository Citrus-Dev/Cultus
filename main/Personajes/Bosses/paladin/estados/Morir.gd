extends State
# Hacer una animacion y al terminar emitir una señal

func enter(msg : Dictionary = {}) -> void:
	owner.hurtbox_contacto.is_constant = false
	owner.hurtbox_pignia.is_constant = false
	owner.hurtbox_giro.is_constant = false
	
	owner.input = Vector2.ZERO
	owner.fase2_revertir_color()
	
	owner.set_animacion("morir")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	return


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	return 
