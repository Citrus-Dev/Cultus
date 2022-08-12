class_name BarraHPBoss
extends Node2D

const UI = preload("res://main/UI/BarraHPBoss/BarraHPBossUI.tscn")

export(NodePath) var objetivo_dir
export(String) var objetivo_group

var objetivo : Node
var barra : BarraHPBossUI
var activo : bool

func setup():
	if objetivo == null:
		if objetivo_dir:
			objetivo = get_node(objetivo_dir)
		elif objetivo_group:
			objetivo = get_tree().get_nodes_in_group(objetivo_group)[0]
		else:
			call_deferred("free")
			return
	instanciar_barra()


func instanciar_barra():
	barra = UI.instance()
	barra.connect("objetivo_muerto", self, "borrar_barra")
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	hud.add_child(barra)
	yield(get_tree(), "idle_frame")
	barra.setup_barra(objetivo)


func borrar_barra():
	yield(get_tree().create_timer(0.8), "timeout")
	if !is_instance_valid(barra): return
	barra.call_deferred("free")


func set_activo(_bool : bool):
	setup()
	activo = _bool
	if is_instance_valid(barra):
		barra.visible = _bool
