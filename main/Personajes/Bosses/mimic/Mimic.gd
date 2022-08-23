class_name Mimic
extends Personaje

export(NodePath) onready var col = get_node(col) as CollisionShape2D
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox

# Ataques:
# Volar tirando proyectiles
# Cargar al jugador
# Rayo de sans

var activo: bool setget set_activo

func set_activo(toggle: bool):
	activo = toggle
	if activo:
		col.disabled = true
	else:
		col.disabled = false

func _ready():
	set_activo(true)

