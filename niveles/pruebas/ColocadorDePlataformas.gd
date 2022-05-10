# Coloca plataformas de propagacion infinitamente en una direccion hasta chocar con algo
# Setea los vecinos automaticamente
tool
class_name ColocadorDePlataformas
extends Position2D

enum ESTADOS {
	ESPERANDO, EMPEZAR, BORRAR_PLATAFORMAS
}
enum DIRS {
	DERECHA,
	IZQUIERDA
}

export(ESTADOS) var cambia_para_empezar setget empezar
export(DIRS) var direccion
export(float, 1, 1200) var distancia
export(float) var espacio_entre_plataformas
var plataformas : Array

func empezar(_valor_innecesario):
	if _valor_innecesario == ESTADOS.BORRAR_PLATAFORMAS:
		for i in plataformas:
			free()
		print_debug("Plataformas borradas.")
		return
	
	if _valor_innecesario != ESTADOS.EMPEZAR:
		return
	
	print_debug("Empezando...")
	
	var plat = PlataformaPropagacion.new()
	var count = plataformas.size()
	add_child(plat, true)
	plat.set_owner(self)
	plataformas.append(plat)
	print(count, " / ", plat)
	
#	var distancia_cubierta : float 
#	while distancia_cubierta < distancia:
#		var plat = PlataformaPropagacion.new()
#		var count = get_child_count()
#		add_child(plat)
#		position.x += count * espacio_entre_plataformas
#		distancia_cubierta += abs(position.x)
