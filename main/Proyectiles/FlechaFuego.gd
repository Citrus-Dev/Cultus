class_name FlechaFuego
extends ProyectilBase

func hit(target: Node):
	# Quemar si es aglgo que podemos quemar
	if target.owner is Personaje:
		var fuego = Fuego.new()
		target.owner.add_child(fuego)
