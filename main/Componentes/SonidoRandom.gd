class_name SonidoRandom
extends Node2D
# Este codigo no esta probado!!!!!

enum StreamPlayer {
	AUDIO_STREAM_PLAYER_2D,
	AUDIO_STREAM_PLAYER
}

export(Array) var sonido_dirs
export(StreamPlayer) var tipo_de_stream_player

var sonidos: Array

func _ready():
	for s in sonido_dirs:
		var p : AudioStreamPlayer = AudioStreamPlayer2D.new() if tipo_de_stream_player == StreamPlayer.AUDIO_STREAM_PLAYER_2D else AudioStreamPlayer.new()
		p.stream = load(s)


func hacer_sonido_random():
	var rng : int = randi() % sonidos.size()
	sonidos[rng].play()
