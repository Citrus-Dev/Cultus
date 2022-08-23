class_name Mimic
extends Personaje

const CAST_PISO_DIST := 160.0

export(NodePath) onready var sprite_inactivo = get_node(sprite_inactivo) as Sprite
export(NodePath) onready var sprite_activo = get_node(sprite_activo) as Sprite
export(NodePath) onready var col = get_node(col) as CollisionShape2D
export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var trigger_wake = get_node(trigger_wake) as TriggerOnce

export(NodePath) onready var rc_piso = get_node(rc_piso) as RayCast2D
export(NodePath) onready var rc_izq = get_node(rc_izq) as RayCast2D
export(NodePath) onready var rc_der = get_node(rc_der) as RayCast2D

# Ataques:
# Volar tirando proyectiles
# Cargar al jugador
# Rayo de sans

var activo: bool setget set_activo
var input_actual: int = 1

func set_activo(toggle: bool):
	activo = toggle
	if activo:
		sprite_activo.visible = true
		sprite_inactivo.visible = false
		
		col.disabled = false
		hurtbox.monitoring = true
		hitbox.set_collision_layer_bit(32, true)
		
		position.y -= 32.0
	else:
		trigger_wake.connect("triggered", self, "wake", [], CONNECT_ONESHOT)
		
		sprite_activo.visible = false
		sprite_inactivo.visible = true
		
		col.disabled = true
		hurtbox.monitoring = false
		hitbox.set_collision_layer_bit(32, false)


func _ready():
	set_activo(false)


func _draw():
	draw_line(Vector2.ZERO, input * 32.0, Color.green, 3.0)


func _process(delta):
	update()
	rc_piso.cast_to.y = osciliar(CAST_PISO_DIST, 0.8, 32.0)


func _physics_process(delta):
	if activo: volar(delta)


func procesar_movimiento(_delta : float):
	if !muerto:
		movement_omni()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	input = Vector2.ZERO


func start_wake():
	trigger_wake.disconnect("triggered", self, "start_wake")
	efecto_wakeup()
	animador.play("wake")


func wake():
	set_activo(true)


func efecto_wakeup():
	var efec := EfectoCirculo.new(Color.white, 1.0, 196.0, 0.4)
	add_child(efec)


func volar(delta: float):
	input.y = -1 if rc_piso.is_colliding() else 1
	input.x = input_actual
	
	if input_actual == 1 and rc_der.is_colliding():
		input_actual = -1
	elif input_actual == -1 and rc_izq.is_colliding():
		input_actual = 1


func osciliar(_x :float, _freq : float, _amplitud : float) -> float:
	_x += cos(OS.get_ticks_msec() * _freq) * _amplitud
	return _x
