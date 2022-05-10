class_name Hitbox
extends Area2D

signal start_i
signal end_i

export(NodePath) onready var status = get_node(status) as Status # A quien pertenece esta hitbox
export(float) var i_frames_tiempo = 0.5

var i_timer = Timer.new()
var desactivado : bool

func _ready() -> void:
	add_child(i_timer)
	i_timer.one_shot = true
	i_timer.connect("timeout", self, "emit_signal", ["end_i"])


func recibir_dmg(_info : InfoDmg = default_info_dmg()):
	if desactivado or !i_timer.is_stopped(): 
		return
	if i_frames_tiempo != 0.0: 
		i_timer.start(i_frames_tiempo)
		emit_signal("start_i")
	status.aplicar_dmg(_info)


func default_info_dmg() -> InfoDmg:
	var dmg = InfoDmg.new()
	dmg.objetivo = self
	dmg.atacante = self
	dmg.dmg_cantidad = 1
	return dmg
