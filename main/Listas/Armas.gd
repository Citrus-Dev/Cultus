# Clase para acceder la lista de armas
class_name Armas
extends Reference

var armas_lista := {
	"ArmaAR" : "res://main/Armas/ArmaAR.gd",
	"ArmaEscopeta" : "res://main/Armas/ArmaEscopeta.gd",
	"ArmaPistola" : "res://main/Armas/ArmaRevolver.gd",
	"ArmaBallesta" : "res://main/Armas/ArmaBallesta.gd",
	"ArmaGauss" : "res://main/Armas/ArmaGauss.gd",
	"ArmaCultista" : "res://main/Armas/ArmaCultista.gd",
	"ArmaRevolverEsqueleto" : "res://main/Armas/ArmaRevolverEsqueleto.gd"
}


func tomar_obj_lista(_key : String):
	if !armas_lista.has(_key):
		return
	
	var l = load(armas_lista[_key])
	return l
