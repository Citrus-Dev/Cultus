class_name SonidosDePasos
extends Node

export(Array, String) var sonidos
export var volumen_extra: float

var sonidos_cargados: Array


func _ready():
	for i in sonidos:
		if ResourceLoader.exists(i):
			sonidos_cargados.append(load(sonidos))


func hacer_sonido_random():
	if sonidos_cargados.empty(): return
	var index: int = randi() % sonidos_cargados.size()
	Musica.hacer_sonido( sonidos_cargados[index], Vector2.ZERO, volumen_extra, false )
