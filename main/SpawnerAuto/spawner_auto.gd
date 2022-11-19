tool
class_name SpawnerAuto
extends Position2D

const SPAWN_EFFECT := preload("res://main/particulas/ParticulasSpawn.tscn")
const SND_SPAWN := preload("res://assets/sfx/spawn.wav")

signal spawn_muerto

export(PackedScene) var spawn setget set_spawn_object
export(String) var spawn_group
export(bool) var spawn_on_ready
export(bool) var efecto = true
export(float) var spawn_continuo_intervalo
export(float) var windup_spawn

var cont_spawns : int 
var spawn_continuo_timer: Timer

var node_spawn: Node2D

func puede_spawn_continuo() -> bool:
	return spawn_continuo_intervalo > 0.0


func _init():
	add_to_group("spawners")


func _ready():
	if spawn_on_ready: call_deferred("spawn")
	if puede_spawn_continuo():
		spawn_continuo_timer = Timer.new()
		add_child(spawn_continuo_timer)
		spawn_continuo_timer.connect("timeout", self, "spawn")


func spawn():
	if Engine.editor_hint or spawn == null:
		return
	
	if puede_spawn_continuo():
		spawn_continuo_timer.start(spawn_continuo_intervalo)
	
	if windup_spawn > 0:
		Musica.hacer_sonido(SND_SPAWN, global_position, -15)
		hacer_efecto()
		yield(get_tree().create_timer(windup_spawn, false), "timeout")
	
	hacer_efecto()
	
	var new_inst = spawn.instance()
	
	if spawn_group != "":
		new_inst.add_to_group(spawn_group)
	
	new_inst.global_position = global_position
	get_parent().add_child(new_inst)
	new_inst.connect("muerto", self, "on_spawn_muerto")
	
	new_inst.name += name + str(cont_spawns)
	cont_spawns += 1
	
	if new_inst is Personaje:
		var p: Jugador = get_tree().get_nodes_in_group("Jugador")[0]
		new_inst.objetivo = p
		new_inst.emit_signal("objetivo_encontrado")
	
	Musica.hacer_sonido(SND_SPAWN, global_position)
	
	node_spawn = new_inst
	return new_inst


func set_spawn_object(_new_spawn : PackedScene):
	spawn = _new_spawn
	
	if !Engine.editor_hint:
		return
	
	if spawn != null:
		var test_inst = spawn.instance()
		print(test_inst.name)
		var spr = find_packedscene_sprite(test_inst)
		if spr is Array:
			get_node("Sprite").texture = spr[0].texture
			get_node("Sprite").hframes = spr[1]
			get_node("Sprite").vframes = spr[2]
			get_node("Sprite").offset = spr[3]
			get_node("Sprite").modulate.a = 0.3
		test_inst.free()
	else:
		get_node("Sprite").texture = null


func hacer_efecto():
	if efecto:
		var inst = SPAWN_EFFECT.instance()
		get_tree().root.add_child(inst)
		inst.global_position = global_position



func find_packedscene_sprite(_instance : Node):
	var sprite : Sprite = null
	for i in _instance.get_children():
		if i is Sprite and i.name == "TestSprite":
			sprite = i
			break
	
	if sprite == null:
		return "ERR"
	else:
		return [sprite, sprite.hframes, sprite.vframes, sprite.offset]


func on_spawn_muerto():
	emit_signal("spawn_muerto")

