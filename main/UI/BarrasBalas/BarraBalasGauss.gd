extends HudMedidorBalas

const DIR_TEXTURAS = "res://assets/ui/balas/gauss_balas_"
const DIR_TEXTURAS_EXT = ".tres"
const MAX_NIVEL := 7

var nivel_actual : int setget set_nivel_actual

func init_barra(_max : int, _cant : int):
	set_nivel_actual(_cant)


func set_nivel_actual(cant : int):
	nivel_actual = clamp(cant, 0, MAX_NIVEL)
	determinar_textura_nivel(nivel_actual)
	label.text = str(nivel_actual)
	if cant == 0:
		label.modulate = Color.red
	else:
		label.modulate = Color.white


func determinar_textura_nivel(nivel : int):
	var num = nivel
	var path = DIR_TEXTURAS + str(num) + DIR_TEXTURAS_EXT
	var text : Texture = load(path)
	if text != null:
		text_rec.texture = text
