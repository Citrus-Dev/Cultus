class_name InvBalas
extends Reference

var dict_balas := {
	"Pistola" : {"cant" : 24, "max" : 60},
	"Rifle" : {"cant" : 90, "max" : 240},
	"Escopeta" : {"cant" : 16, "max" : 48},
	"Granadas" : {"cant" : 1, "max" : 6},
	"Cohetes" : {"cant" : 12, "max" : 48},
	"Flechas" : {"cant" : 8, "max" : 24}
}

var medidor : HudMedidorBalas setget set_medidor

func bajar_balas(cant, id):
	var balas = dict_balas[id]
	balas["cant"] = max(balas["cant"] - cant, 0)


func agregar_balas(cant, id):
	var balas = dict_balas[id]
	balas["cant"] = min(balas["cant"] + cant, balas["max"])


func hay_balas(id : String) -> bool:
	return dict_balas[id]["cant"] > 0


func set_medidor(_medidor : HudMedidorBalas):
	medidor = _medidor
	var balas_max = dict_balas[medidor.id_balas]["max"]
	var balas_actual = dict_balas[medidor.id_balas]["cant"]
	medidor.init_barra(balas_max, balas_actual)
