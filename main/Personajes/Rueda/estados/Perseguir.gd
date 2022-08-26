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
	calcular_distancia_a_jugador()
	cambiar_direccion(target_dir)


func unhandled_input(event : InputEvent) -> void:
	return


func process(delta : float) -> void:
	pass


func physics_process(delta : float) -> void:
#	var test: KinematicCollision2D = owner.move_and_collide(owner.velocity, true, true, true)
#	if test != null and test.normal.y == 0:
	if owner.probar_pared():
		cambiar_direccion()


func exit() -> void:
	owner.disconnect("borde_tocado", self, "tocar_borde")


func calcular_distancia_a_jugador():
	if obj == null: return
	var dir_to_jug = obj.global_position - owner.global_position
	target_dir = sign(dir_to_jug.x)
#	dist = abs(dir_to_jug.length())


func cambiar_direccion(dir := owner.input.x * -1.0):
	owner.input.x = dir
	owner.set_dir(dir)
