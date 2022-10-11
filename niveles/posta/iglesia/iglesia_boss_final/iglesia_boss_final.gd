extends Nivel

export(NodePath) onready var camara_boss = get_node(camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta

var limites_derecha: bool
var boss_empezado: bool


func cambiar_a_limites_izq(__):
	if !limites_derecha: 
		return
	
	limites_derecha = false
	primer_limite_camara_obj.get_new_limits()


func cambiar_a_limites_derecha(__):
	if limites_derecha: 
		return
		
	limites_derecha = true
	camara_boss.get_new_limits()



func empezar_boss(__):
	if boss_empezado:
		return
	
	boss_empezado = true
	puerta.cerrar()
