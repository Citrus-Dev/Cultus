class_name FlechaFuego
extends ProyectilBase

func hit(target: Node):
	var fuego = Fuego.new()
	target.owner.add_child(fuego)
