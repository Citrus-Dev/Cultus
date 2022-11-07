extends Nivel

const DATO_PERSIST: String = "AR_agarrado"

export(NodePath) onready var arma_pickup = get_node(arma_pickup) as PickupArma

func _ready():
	if info_persist_nivel.has(DATO_PERSIST):
		# Ya se agarro el arma, borrala
		arma_pickup.call_deferred("free")
	else:
		# No se agarro el arma, hace que se guarde cuando la agarres
		arma_pickup.connect("on_pickup", self, "arma_agarrada")



func arma_agarrada():
	info_persist_nivel[DATO_PERSIST] = true
