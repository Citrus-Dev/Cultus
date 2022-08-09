class_name PickupHP
extends Casquillo

export (NodePath) var path_area
export (int) var cant_hp = 20
export(bool) var no_desaparecer
export(String) var mensaje

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
	var status = _jug.status as Status
	status.curar(cant_hp)
	
	LabelsPickup.agregar_mensaje(
		global_position,
		mensaje.format([str(cant_hp)], "%cant%"),
		1.4,
		Color.green
	)
	
	call_deferred("free")
