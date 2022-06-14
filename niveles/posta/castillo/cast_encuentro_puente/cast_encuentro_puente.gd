extends Nivel

const NOMBRE_DATO := "encuentro_terminado"
const NOMBRE_DATO_PICKUP := "escopeta_agarrada"

export(NodePath) onready var puerta_izq = get_node(puerta_izq) as Puerta
export(NodePath) onready var puerta_der = get_node(puerta_der) as Puerta
export(NodePath) onready var escopeta = get_node(escopeta) as PickupArma
export(NodePath) onready var trigger_encuentro = get_node(trigger_encuentro) as TriggerOnce


func _ready():
	if info_persist_nivel.has(NOMBRE_DATO_PICKUP):
		# Se agarro la escopeta, borrarla
		escopeta.call_deferred("free")
		trigger_encuentro.connect("triggered", self, "comenzar_encuentro")
	else:
		escopeta.connect("on_pickup", self, "registrar_escopeta_agarrada")
	
	if info_persist_nivel.has(NOMBRE_DATO):
		# Ya se hizo el encuentro, abrir la puerta del final
		puerta_der.set_abierto(true)
	


func registrar_escopeta_agarrada():
	info_persist_nivel[NOMBRE_DATO_PICKUP] = true
	comenzar_encuentro()


func comenzar_encuentro():
	puerta_izq.cerrar()
	puerta_der.cerrar()


func terminar_encuentro():
	info_persist_nivel[NOMBRE_DATO] = true
