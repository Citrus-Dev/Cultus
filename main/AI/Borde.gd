# Señaliza a la AI donde saltar
class_name Borde
extends Node2D

enum OPCIONES_FILTRO {
	NO,
	IZQUIERDA,
	DERECHA
}

export(bool) var siempre_saltar
export(float, 0, 1) var mult_fuerza_salto = 1 # Que tanto de la fuerza de salto usar (multiplica)
# El borde solo se va a detectar si el personaje va en esta direccion
# (No funciona, es un problema con el comportamiento strafe no con el borde)
export(OPCIONES_FILTRO) var filtro_salto_direccion

var dir_filtro : Vector2

onready var area : Area2D = get_node("Area2D")

func _ready() -> void:
	match filtro_salto_direccion:
		OPCIONES_FILTRO.IZQUIERDA:
			dir_filtro = Vector2.LEFT
		OPCIONES_FILTRO.DERECHA:
			dir_filtro = Vector2.RIGHT


func on_agent_entered(_body):
	if _body is Personaje:
		_body.detectar_borde(self)
		if _body.get("behavior_tree") != null:
			if filtro_salto_direccion == 0 or determinar_direccion(_body) == dir_filtro:
				var bt : BehaviorTree = _body.behavior_tree
				bt.blackboard.escribir_dato("borde", self)


func on_agent_exited(_body):
	if _body is Personaje:
		if _body.get("behavior_tree") != null:
			var bt : BehaviorTree = _body.behavior_tree 
			bt.blackboard.borrar_dato("borde")


func determinar_direccion(_body : Personaje) -> Vector2:
	var bodyvel : float = _body.velocity.x
	if bodyvel > 0.0:
		# Esta llendo a la derecha
		return Vector2.RIGHT
	else:
		# Esta llendo a la izquierda
		return Vector2.LEFT
