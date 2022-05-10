class_name Prueba
extends Personaje

func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
		var angulo = velocity.angle()
		skin.rotation = angulo
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	input = Vector2.ZERO
