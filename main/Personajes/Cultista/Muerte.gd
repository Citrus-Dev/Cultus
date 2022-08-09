extends State

func enter(msg : Dictionary = {}) -> void:
	owner.animador.play("muerte")
