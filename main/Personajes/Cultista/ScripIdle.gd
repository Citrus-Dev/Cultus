extends State

var user : Personaje
var animador : AnimationPlayer
var skin : Node2D 
var correr_obj : Node2D

func _ready():
	yield(get_tree(), "idle_frame")
	user = owner
	animador = user.animador
	skin = user.skin


func enter(msg : Dictionary = {}) -> void:
	user.input = Vector2.ZERO
	if msg.has("Anim"):
		animador.play(msg["Anim"])
	if msg.has("FlipH"):
		skin.scale.x = -1 if msg["FlipH"] == true else 1
	if msg.has("FlipV"):
		skin.scale.y = -1 if msg["FlipV"] == true else 1
	if msg.has("Oneshot"):
		animador.connect("animation_finished", self, "oneshot_anim", [msg["Oneshot"]])
	if msg.has("CorrerObj"):
		correr_obj = msg["CorrerObj"]
		user.connect("borde_tocado", self, "saltar")
		
		var dir = sign(owner.global_position.direction_to(correr_obj.global_position).x)
		owner.input.x = dir


func exit() -> void:
	if animador.is_connected("animation_finished", self, "oneshot_anim"):
		animador.disconnect("animation_finished", self, "oneshot_anim")
	if owner.is_connected("borde_tocado", self, "saltar"):
		owner.disconnect("borde_tocado", self, "saltar")


func oneshot_anim(__, oneshot_anim : String):
	animador.play(oneshot_anim)


func saltar(_borde : Borde):
	# Si el objetivo esta por encima del dueño de esta maquina de estados
	if user.global_position.y > correr_obj.global_position.y:
		user.jump(user.jump_velocity * _borde.mult_fuerza_salto)
