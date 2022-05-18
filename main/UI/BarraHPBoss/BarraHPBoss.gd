class_name BarraHPBoss
extends Node2D

const UI = preload("res://main/UI/BarraHPBoss/BarraHPBossUI.tscn")

export(NodePath) var objetivo_dir

var objetivo : Node
var barra : BarraHPBossUI
var activo : bool

func _ready():
	yield(get_tree(), "idle_frame")
	objetivo = get_node(objetivo_dir)
	instanciar_barra()
	set_activo(activo)


func instanciar_barra():
	barra = UI.instance()
	barra.connect("objetivo_muerto", self, "borrar_barra")
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	hud.add_child(barra)
	barra.setup_barra(objetivo)


func borrar_barra():
	yield(get_tree().create_timer(0.8), "timeout")
	barra.call_deferred("free")


func set_activo(_bool : bool):
	activo = _bool
	if is_instance_valid(barra):
		barra.visible = _bool
