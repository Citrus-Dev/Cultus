extends Nivel

export(NodePath) onready var camara_boss = get_node(camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var efecto = get_node(efecto) as AnimationPlayer
export(NodePath) onready var boss_spawn = get_node(boss_spawn) as SpawnerAuto

var limites_derecha: bool
var boss_empezado: bool
var boss: BossFinal


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
	
	boss = boss_spawn.spawn()
	boss_empezado = true
	puerta.cerrar()
	efecto.play("o")
	call_deferred("alertar_todos_los_enemigos")
