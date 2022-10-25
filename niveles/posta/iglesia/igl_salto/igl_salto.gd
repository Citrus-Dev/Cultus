extends Nivel

export(NodePath) onready var puerta_grande = get_node(puerta_grande) as Puerta
export(NodePath) onready var summoner = get_node(summoner) as Summoner


func _ready():
	puerta_grande.set_abierto(TransicionesDePantalla.abrio_puerta_boss_final)
	if TransicionesDePantalla.abrio_puerta_boss_final:
		# No espawnear el summoner si ya tenes la llave (para no romper tanto las bolas)
		summoner.call_deferred("free")

