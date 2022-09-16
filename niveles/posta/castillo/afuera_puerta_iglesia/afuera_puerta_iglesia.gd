extends Nivel

export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var trigger_puerta_cerrada = get_node(trigger_puerta_cerrada) as Area2D

func _ready():
	if TransicionesDePantalla.tiene_llave_iglesia:
		puerta.abrir()
		trigger_puerta_cerrada.call_deferred("free")
	else:
		puerta.cerrar()
		trigger_puerta_cerrada.connect("body_entered", self, "mensaje_necesitas_llave")



func mensaje_necesitas_llave(__):
	ControladorUi.mensaje_ui("La puerta esta cerrada... necesitas una llave.", 4.0, true)
