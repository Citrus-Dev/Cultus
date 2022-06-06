# Clase para acceder la lista de armas
class_name Armas
extends Reference

var armas_jugador := [
	"ArmaRevolver",
	"ArmaAR",
	"ArmaEscopeta",
	"ArmaGauss",
	"ArmaBallesta"
]

const armas_lista := {
	"ArmaAR" : "res://main/Armas/ArmaAR.gd",
	"ArmaEscopeta" : "res://main/Armas/ArmaEscopeta.gd",
	"ArmaPistola" : "res://main/Armas/ArmaRevolver.gd",
	"ArmaRevolver" : "res://main/Armas/ArmaRevolver.gd",
	"ArmaBallesta" : "res://main/Armas/ArmaBallesta.gd",
	"ArmaGauss" : "res://main/Armas/ArmaGauss.gd",
	"ArmaCultista" : "res://main/Armas/ArmaCultista.gd",
	"ArmaRevolverEsqueleto" : "res://main/Armas/ArmaRevolverEsqueleto.gd"
}


const skills_lista := {
	"Slide" : "res://main/Pickups/skills/SkillSlide.tscn",
	"Bufanda" : "res://main/Pickups/skills/SkillBufanda.tscn",
	"Escudo" : "res://main/Pickups/skills/SkillEscudo.tscn"
}


func tomar_obj_lista(_key : String):
	if !armas_lista.has(_key):
		return
	
	var l = load(armas_lista[_key])
	return l
