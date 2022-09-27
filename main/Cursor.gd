class_name Cursor
extends Sprite

enum CursorEstilo {
	MENU,
	CROSSHAIR
}

const SPR_CURSOR_MENU := preload("res://assets/ui/cursor_menu.png")
const SPR_CURSOR_CROSSHAIR := preload("res://assets/ui/cursor.png")


func set_cursor_estilo(estilo: int):
	match estilo:
		CursorEstilo.MENU:
			texture = SPR_CURSOR_MENU
		CursorEstilo.CROSSHAIR:
			texture = SPR_CURSOR_CROSSHAIR



func _ready():
	set_cursor_estilo(CursorEstilo.MENU)
	z_index = VisualServer.CANVAS_ITEM_Z_MAX 




func _process(delta):
	global_position = get_global_mouse_position()
