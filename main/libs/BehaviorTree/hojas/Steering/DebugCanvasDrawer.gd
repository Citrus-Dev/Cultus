# Para pruebas, dibuja info del steering
class_name DebugCanvasDrawer
extends Node2D

var steer 

func _init(_owner) -> void:
	steer = _owner


func _draw() -> void:
	if steer.agente:
		for i in steer.rayos:
			var color : Color = Color.orange
			if i in steer.peligro:
				color = Color.red
			if i in steer.interes:
				color = Color.green
			
			draw_line(
				steer.agente.position,
				steer.agente.position + i * steer.distancia_de_deteccion,
				Color.orange,
				.5
			)
		
		draw_line(
			steer.agente.position,
			steer.agente.position + steer.dir_final * steer.distancia_de_deteccion,
			Color.green,
			2.5
		)
		
		draw_line(
			steer.agente.position,
			steer.agente.position + steer.dir_avoid * steer.distancia_de_deteccion,
			Color.red,
			2.5
		)
