# Recurso que guarda datos globales como la versión.
class_name InfoJuego
extends Resource

const SLOT_GUARDADO_JUGADOR := "Jug"
const INV_BALAS_DEFAULT := {
	"Pistola" : {"cant" : 24, "max" : 60},
	"Rifle" : {"cant" : 90, "max" : 240},
	"Escopeta" : {"cant" : 16, "max" : 48},
	"Granadas" : {"cant" : 1, "max" : 6},
	"Cohetes" : {"cant" : 6, "max" : 6},
	"Flechas" : {"cant" : 8, "max" : 24}
}

export(String) var version_actual
export(Array, String) var creditos
export(String) var primer_nivel
