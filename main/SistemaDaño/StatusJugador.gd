class_name StatusJugador
extends Status

func init_base():
	add_child(timer_stun)
	timer_stun.one_shot = true
	timer_stun.wait_time = TIEMPO_REDUCCION_STUN
	
	hp = hp_max if ControladorUi.jug_hp == 0 else ControladorUi.jug_hp
	actualizar_hp_bar()
