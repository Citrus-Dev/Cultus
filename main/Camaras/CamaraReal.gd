class_name CamaraReal
extends Camera2D

const VEL_POS : float = 5.0
const VEL_OFFSET : float = 2.0
const VEL_CAMBIO_LIMITES : float = 0.7

var camara_falsa : CamaraFalsa
var view_offset : Vector2
var shaker := Shaker.new()

func _ready() -> void:
	shaker.decay = 1.5
	shaker.max_offset = Vector2(5, 5)
	shaker.target = self
	shaker.use_offset_value = true
	add_child(shaker)
	
	global_position = camara_falsa.global_position
	camara_falsa.connect("cambio_de_limites", self, "actualizar_limites")
	get_tree().get_nodes_in_group("Nivel")[0].init_primer_limite()


func _physics_process(delta: float) -> void:
	if is_instance_valid(camara_falsa):
		global_position = lerp(global_position, camara_falsa.global_position + view_offset, VEL_POS * delta)
		view_offset = lerp(view_offset, camara_falsa.offset, VEL_OFFSET * delta)


func actualizar_limites(_instant : bool):
	if _instant:
		actualizar_limites_instantaneo()
		return
	
	var new_tween = Tween.new()
	add_child(new_tween)
	
	tween_limit(new_tween, "limit_top")
	tween_limit(new_tween, "limit_bottom")
	tween_limit(new_tween, "limit_left")
	tween_limit(new_tween, "limit_right")
	
	yield(new_tween, "tween_all_completed")
	new_tween.call_deferred("free")


func tween_limit(_tween : Tween, _limit_property_name : String):
	var self_limit = get(_limit_property_name)
	var target_limit = camara_falsa.get(_limit_property_name)
	
	_tween.interpolate_property(
		self,
		_limit_property_name,
		self_limit,
		target_limit,
		VEL_CAMBIO_LIMITES,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	_tween.start()


func actualizar_limites_instantaneo():
	limit_top = camara_falsa.limit_top
	limit_bottom = camara_falsa.limit_bottom
	limit_left = camara_falsa.limit_left
	limit_right = camara_falsa.limit_right


func aplicar_screenshake(_trauma : float):
	shaker.add_trauma(_trauma)
