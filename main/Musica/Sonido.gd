class_name Sonido
extends Node2D


var snd


func _init(_sonido: AudioStream, vol_over := 0.0, _2d: bool = false):
	snd = AudioStreamPlayer2D.new() if _2d else AudioStreamPlayer.new()
	snd.playing = false
	snd.volume_db = vol_over
	snd.stream = _sonido
	snd.connect("finished", self, "borrar")


func _ready():
	add_child(snd)
	snd.play()




func borrar():
	call_deferred("free")
