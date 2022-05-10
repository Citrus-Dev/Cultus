class_name LabelFuenteAdaptable
extends Node

# Este script le aplica la fuente global al control que tenga de padre
# Esto es para poder cambiarle el tamaño a las letras pero forzar 
# igual que usen ciertos parametros del tema global

onready var padre : Control = get_parent()

onready var font = load(ProjectSettings.get("gui/theme/custom_font")) as DynamicFont
onready var font_data = load(ProjectSettings.get("gui/theme/custom_font")).font_data as DynamicFontData


func _ready():
	padre.get_font("font").font_data = font_data
