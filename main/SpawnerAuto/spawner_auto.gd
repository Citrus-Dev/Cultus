tool
class_name SpawnerAuto
extends Position2D

signal spawn_muerto

export(PackedScene) var spawn setget set_spawn_object
export(bool) var spawn_on_ready
export(bool) var one_shot

var cont_spawns : int 

func _ready():
	if spawn_on_ready: call_deferred("spawn")


func spawn():
	if Engine.editor_hint or spawn == null:
		return
	
	var new_inst = spawn.instance()
	new_inst.global_position = global_position
	get_parent().add_child(new_inst)
	if one_shot: call_deferred("free")
	new_inst.connect("muerto", self, "emit_signal", ["spawn_muerto"])
	
	new_inst.name += name + str(cont_spawns)
	cont_spawns += 1


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
