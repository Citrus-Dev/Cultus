class_name BarraHPBossUI
extends Control

signal objetivo_muerto

onready var barra : ProgressBar = get_node("MarginContainer/VBoxContainer/Barra/ProgressBar")
var objetivo : Personaje

func setup_barra(_objetivo : Personaje):
	objetivo = _objetivo
	var status = objetivo.status as Status
	barra.value = status.hp
	barra.max_value = status.hp_max
	status.connect("aplicar_dmg", self, "cambiar_vida")
	status.connect("morir", self, "emit_signal", ["objetivo_muerto"])


func cambiar_vida(_dmg : InfoDmg):
	barra.value -= _dmg.dmg_cantidad
