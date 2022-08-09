class_name PickupVarianteArma
extends Node2D

export(String) var arma
export(int) var id_variante

func _ready():
	$Area2D.connect("body_entered", self, "agarrar")


func agarrar(jug: Jugador):
	if !TransicionesDePantalla.inv_variantes.has(arma):
		TransicionesDePantalla.inv_variantes[arma] = []
	TransicionesDePantalla.inv_variantes[arma].append(id_variante)
	call_deferred("free")
