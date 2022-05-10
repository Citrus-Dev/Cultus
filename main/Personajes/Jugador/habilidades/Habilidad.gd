# Superclase para habilidades
class_name Habilidad
extends Node

var jugador : Jugador 
var contexto_usable : bool # Si podes usar la habilidad

func _ready():
	jugador = owner


func _physics_process(delta):
	detectar_usable()
	if contexto_usable: detectar_activacion(delta)


# Se fija si podes usar la habilidad
func detectar_usable():
	pass


# Se fija si tocaste el input para hacer la habilidad
func detectar_activacion(delta):
	pass


func activar():
	pass

