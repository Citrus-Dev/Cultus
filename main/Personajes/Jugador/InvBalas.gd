class_name InvBalas
extends Reference

signal balas_cambiadas(_self)

var dict_balas := {
	"Pistola" : {"cant" : 24, "max" : 60},
	"Rifle" : {"cant" : 90, "max" : 240, "min" : 30},
	"Escopeta" : {"cant" : 16, "max" : 48, "min" : 10},
	"Granadas" : {"cant" : 1, "max" : 6, "min" : 0},
	"Cohetes" : {"cant" : 6, "max" : 6, "min" : 6}, # e diablo :0
	"Flechas" : {"cant" : 8, "max" : 24, "min" : 3}
}

var medidor : HudMedidorBalas setget set_medidor

func bajar_balas(cant, id):
	var balas = dict_balas[id]
	balas["cant"] = max(balas["cant"] - cant, 0)
	emit_signal("balas_cambiadas", dict_balas)


func agregar_balas(cant, id):
	var balas = dict_balas[id]
	balas["cant"] = min(balas["cant"] + cant, balas["max"])
	emit_signal("balas_cambiadas", dict_balas)


func hay_balas(id : String, minimo : int = 0) -> bool:
	return dict_balas[id]["cant"] > minimo


func set_medidor(_medidor : HudMedidorBalas):
	if _medidor == null: return
	medidor = _medidor
	var balas_max = dict_balas[medidor.id_balas]["max"]
	var balas_actual = dict_balas[medidor.id_balas]["cant"]
	medidor.init_barra(balas_max, balas_actual)


# Te da el inventario de balas con solo las armas que descubriste
func tomar_balas_descubiertas() -> Dictionary:
	var nuevo_inv : Dictionary
#	if TransicionesDePantalla.inv_armas.has("PISTOLA"):
#		nuevo_inv["Pistola"] = dict_balas["Pistola"]
	
	if TransicionesDePantalla.inv_armas.has("ESCOPETA"):
		nuevo_inv["Escopeta"] = dict_balas["Escopeta"]
	
	if TransicionesDePantalla.inv_armas.has("RIFLE"):
		nuevo_inv["Rifle"] = dict_balas["Rifle"]
		nuevo_inv["Granadas"] = dict_balas["Granadas"]
	
	if TransicionesDePantalla.inv_armas.has("BALLESTA"):
		nuevo_inv["Flechas"] = dict_balas["Flechas"]
	
	if TransicionesDePantalla.inv_armas.has("BAZUCA"):
		nuevo_inv["Cohetes"] = dict_balas["Cohetes"]
	
	return nuevo_inv


func agregar_minimo_de_balas():
	if TransicionesDePantalla.inv_armas.has("ESCOPETA"):
		if dict_balas["Escopeta"]["cant"] < dict_balas["Escopeta"]["min"]:
			dict_balas["Escopeta"]["cant"] = dict_balas["Escopeta"]["min"]
	
	if TransicionesDePantalla.inv_armas.has("RIFLE"):
		if dict_balas["Rifle"]["cant"] < dict_balas["Rifle"]["min"]:
			dict_balas["Rifle"]["cant"] = dict_balas["Rifle"]["min"]
	
	if TransicionesDePantalla.inv_armas.has("BALLESTA"):
		if dict_balas["Flechas"]["cant"] < dict_balas["Flechas"]["min"]:
			dict_balas["Flechas"]["cant"] = dict_balas["Flechas"]["min"]
	
	if TransicionesDePantalla.inv_armas.has("BAZUCA"):
		if dict_balas["Cohetes"]["cant"] < dict_balas["Cohetes"]["min"]:
			dict_balas["Cohetes"]["cant"] = dict_balas["Cohetes"]["min"]
	
	# aaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	var jug: Jugador = TransicionesDePantalla.get_tree().get_nodes_in_group("Jugador")[0]
	jug.controlador_armas.arma_actual.actualizar_medidor()


