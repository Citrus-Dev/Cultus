extends Casquillo

export (NodePath) var path_area
export (String) var nombre_bala
export (int) var cant_bala
export(bool) var no_desaparecer

onready var area = get_node(path_area)

func _ready():
	area.connect("body_entered", self, "agarrar")


func proceso(delta):
	if !no_desaparecer and contador_lifetime < LIFETIME:
		modulate.a = curva_fade.interpolate(contador_lifetime / LIFETIME)
	
	if !no_desaparecer: contador_lifetime -= delta
	if contador_lifetime <= 0:
		call_deferred("free")


func agarrar(_jug):
	var inv : InvBalas = _jug.controlador_armas.inv_balas
	var arma : Arma = _jug.controlador_armas.arma_actual
	inv.agregar_balas(cant_bala, nombre_bala)
	if arma.has_method("actualizar_medidor"):
		arma.actualizar_medidor()
	call_deferred("free")
