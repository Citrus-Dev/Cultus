class_name PickupSkill
extends Node2D

export(NodePath) onready var area = get_node(area) as Area2D
export(NodePath) onready var anim = get_node(anim) as AnimationPlayer
export(String) var id_skill
export(String) var mensaje

onready var armas := Armas.new()
onready var altura_inicial := position.y

func _ready():
	if es_valido():
		printerr("La cagaste")
		call_deferred("free")
	area.connect("body_entered", self, "pickup")
	anim.play("loop")


func _process(delta):
	position.y = anim_levitar(position.y, 0.4 * delta, 0.3)


func anim_levitar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x


func es_valido() -> bool:
	return !armas.skills_lista.has(id_skill)


func pickup(jug : Jugador):
	jug.agregar_skill(id_skill)
	call_deferred("free")
	ControladorUi.emit_signal("mensaje_ui", mensaje, 10, true)
