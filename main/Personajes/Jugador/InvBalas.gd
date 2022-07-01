class_name InvBalas
extends Reference

signal balas_cambiadas(_self)

var dict_balas := {
	"Pistola" : {"cant" : 24, "max" : 60},
	"Rifle" : {"cant" : 90, "max" : 240},
	"Escopeta" : {"cant" : 16, "max" : 48},
	"Granadas" : {"cant" : 1, "max" : 6},
	"Cohetes" : {"cant" : 6, "max" : 6},
	"Flechas" : {"cant" : 8, "max" : 24}
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
