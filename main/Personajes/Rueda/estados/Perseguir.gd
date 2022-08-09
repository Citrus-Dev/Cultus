extends State

var animador : AnimationPlayer
var obj : Jugador
var target_dir : float

func _ready():
	animador = owner.get_node("Skin/AnimationPlayer")


func enter(msg : Dictionary = {}) -> void:
	obj = owner.objetivo 
	owner.connect("borde_tocado", self, "tocar_borde")
	animador.play("alerta")


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	calcular_distancia_a_jugador()
	owner.set_dir(target_dir)
	owner.input.x = target_dir


func physics_process(delta : float) -> void:
	return


func exit() -> void:
	owner.disconnect("borde_tocado", self, "tocar_borde")


func calcular_distancia_a_jugador():
	var dir_to_jug = obj.global_position - owner.global_position
	target_dir = sign(dir_to_jug.x)
#	dist = abs(dir_to_jug.length())
