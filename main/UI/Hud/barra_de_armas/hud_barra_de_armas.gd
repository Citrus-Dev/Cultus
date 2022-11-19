class_name HudBarraDeArmas
extends Control

const FADE_DURACION: float = 0.5
const DISPLAY_ESCENA := preload("res://main/UI/Hud/barra_de_armas/display_arma.tscn")

export(NodePath) onready var contenedor_paneles = get_node(contenedor_paneles) as Container

var timer_visible: Timer

func _ready() -> void:
	timer_visible = Timer.new()
	add_child(timer_visible)
	timer_visible.one_shot = true
	toggle_visible(false, true)
	
	# Esperar unos segundos asi no aparece el medidor cada vez que cambias de nivel
#	yield(get_tree().create_timer(0.5, true), "timeout")
	
	timer_visible.connect("timeout", self, "toggle_visible", [false])
	ControladorUi.connect("arma_nueva_agarrada", self, "update_arma_agarrada")
	ControladorUi.connect("arma_actual_cambiada", self, "update_arma_seleccionada")




func toggle_visible(toggle: bool, instant: bool = false):
	var t := Tween.new()
	add_child(t)
	
	if instant:
		modulate.a = 1 if toggle else 0
	else:
		t.interpolate_property(
			self,
			"modulate:a",
			modulate.a,
			1 if toggle else 0,
			FADE_DURACION
		)
		t.start()
	
	if toggle:
		timer_visible.start()



func update_arma_agarrada(arma: Arma):
	toggle_visible(true)
	crear_display_de_armas(arma)


func update_arma_seleccionada(arma: Arma):
	toggle_visible(true)
	
	for i in contenedor_paneles.get_children():
		var display_actual: HudDisplayArma = i as HudDisplayArma
		display_actual.set_select(display_actual.slot == arma.slot)



func crear_display_de_armas(arma: Arma):
	# Revisar que no haya displays duplicados
	for i in contenedor_paneles.get_children():
		var display_actual: HudDisplayArma = i as HudDisplayArma
		if display_actual.slot == arma.slot: return
	
	
	var nuevo: HudDisplayArma = DISPLAY_ESCENA.instance()
	nuevo.slot = arma.slot
	contenedor_paneles.add_child(nuevo)
	contenedor_paneles.move_child(nuevo, arma.slot)
	
	nuevo.textura_arma.texture = arma.textura_hud_selec


func sort_by_slot(disp1: HudDisplayArma, disp2: HudDisplayArma) -> bool:
	return disp1.slot < disp2.slot

