extends ColorRect

# trolin
func _process(delta):
	color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
