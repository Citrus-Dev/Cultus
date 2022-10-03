# Nodo que spawnea enemigos al azar y luego se borra a si mismo
# Agarra de una lista de posibles spawns
class_name SummonRandom
extends Node2D

signal enemigo_spawneado(enemigo)

const SPAWN_EFFECT := preload("res://main/particulas/ParticulasSpawn.tscn")

const ESCENA_CULTISTA := preload("res://main/Personajes/Cultista/Cultista.tscn")
const ESCENA_SUBDITO := preload("res://main/Personajes/Subdito/Subdito.tscn")
const ESCENA_CABALLERO := preload("res://main/Personajes/Caballero/Caballero.tscn")
const ESCENA_POLILLA := preload("res://main/Personajes/Polilla/Polilla.tscn")
const ESCENA_RUEDA := preload("res://main/Personajes/Rueda/Rueda.tscn")
const ESCENA_ESQUELETO := preload("res://main/Personajes/Esqueleto/Esqueleto.tscn")
const ESCENA_CASTER := preload("res://main/Personajes/Shot/Shot.tscn")

enum Spawns {
	UNA_POLILLA = 0,
	DOS_POLILLAS = 1,
	TRES_POLILLAS = 2,
	UN_CULTISTA = 3,
	DOS_CULTISTAS = 4,
	CINCO_SUBDITOS = 5,
	DOS_ESQUELETOS = 6,
	DOS_CABALLEROS = 7,
	TRES_RUEDAS = 8,
	UN_CABALLERO = 9,
	UN_CASTER = 10
}


var spawner: Node2D


func _init(n_spawner: Node2D):
	spawner = n_spawner


func spawn_random():
	var elegido: int = randi() % Spawns.keys().size()
	print("Spawn random elegido: " +  str(Spawns.keys()[elegido]))
	
	match elegido:
		Spawns.UNA_POLILLA:
			spawnear_enemigo(ESCENA_POLILLA, global_position)
		Spawns.DOS_POLILLAS:
			spawnear_enemigo(ESCENA_POLILLA, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_POLILLA, global_position + Vector2(-45, 0))
		Spawns.TRES_POLILLAS:
			spawnear_enemigo(ESCENA_POLILLA, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_POLILLA, global_position + Vector2(-45, 0))
			spawnear_enemigo(ESCENA_POLILLA, global_position + Vector2(0, -25))
		Spawns.UN_CULTISTA:
			spawnear_enemigo(ESCENA_CULTISTA, global_position)
		Spawns.DOS_CULTISTAS:
			spawnear_enemigo(ESCENA_CULTISTA, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_CULTISTA, global_position + Vector2(-45, 0))
		Spawns.CINCO_SUBDITOS:
			spawnear_enemigo(ESCENA_SUBDITO, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_SUBDITO, global_position + Vector2(-45, 0))
			spawnear_enemigo(ESCENA_SUBDITO, global_position + Vector2(0, -25))
		Spawns.DOS_ESQUELETOS:
			spawnear_enemigo(ESCENA_ESQUELETO, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_ESQUELETO, global_position + Vector2(-45, 0))
		Spawns.DOS_CABALLEROS:
			spawnear_enemigo(ESCENA_CABALLERO, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_CABALLERO, global_position + Vector2(-45, 0))
		Spawns.TRES_RUEDAS:
			spawnear_enemigo(ESCENA_RUEDA, global_position + Vector2(45, 0))
			spawnear_enemigo(ESCENA_RUEDA, global_position + Vector2(-45, 0))
			spawnear_enemigo(ESCENA_RUEDA, global_position + Vector2(0, -25))
		Spawns.UN_CABALLERO:
			spawnear_enemigo(ESCENA_CABALLERO, global_position)
		Spawns.UN_CASTER:
			spawnear_enemigo(ESCENA_CASTER, global_position)
	
	call_deferred("free")


func spawnear_enemigo(enemigo: PackedScene, pos: Vector2):
	var inst = enemigo.instance()
	inst.global_position = pos
	
	spawner.get_parent().add_child(inst)
	
	hacer_efecto_spawn(pos)
	emit_signal("enemigo_spawneado", inst)
	
	# Alertar los enemigos spawneados
	var jug = get_tree().get_nodes_in_group("Jugador")[0]
	inst.objetivo = jug
	inst.emit_signal("objetivo_encontrado")


func hacer_efecto_spawn(pos: Vector2):
	var inst = SPAWN_EFFECT.instance()
	inst.global_position = pos
	get_tree().root.add_child(inst)











