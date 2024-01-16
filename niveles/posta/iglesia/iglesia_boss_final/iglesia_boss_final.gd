extends Nivel

export(NodePath) onready var camara_boss = get_node(camara_boss) as CameraBounds
export(NodePath) onready var puerta = get_node(puerta) as Puerta
export(NodePath) onready var efecto = get_node(efecto) as AnimationPlayer
export(NodePath) onready var cult_cinematica = get_node(cult_cinematica) as AnimationPlayer
export(NodePath) onready var efecto_muerto = get_node(efecto_muerto) as AnimationPlayer
export(NodePath) onready var fadeout = get_node(fadeout) as AnimationPlayer
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



func animar_cultista_cinematica(__ = ""):
	if boss_empezado:
		return
	
	boss_empezado = true
	puerta.cerrar()
	cult_cinematica.play("o")
	
	yield(cult_cinematica, "animation_finished")
	
	empezar_boss()



func empezar_boss(__ = ""):
	boss = boss_spawn.spawn()
	Musica.reiniciar_musica()
	efecto.play("o")
	call_deferred("alertar_todos_los_enemigos")



func boss_muerto():
	efecto_muerto.play("o")
	
	fadeout.play("o")
	yield(fadeout, "animation_finished")
	GameState.ver_credtios()

