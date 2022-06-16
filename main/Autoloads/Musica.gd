extends Node

enum Tracks {
	MUS_MENU,
	MUS_NORMAL,
	MUS_COMBATE
}
var track_actual : int setget cambiar_musica
var objetivo_actual : AudioStream

var musica : ResCancion

var stream_player_1 : AudioStreamPlayer
var stream_player_2 : AudioStreamPlayer
var stream_player_actual : AudioStreamPlayer
var stream_player_no_actual : AudioStreamPlayer
var tween : Tween

var is_ready : bool

func _ready():
	stream_player_1 = AudioStreamPlayer.new()
	stream_player_1.bus = "Musica"
	add_child(stream_player_1)
	
	stream_player_2 = AudioStreamPlayer.new()
	stream_player_2.bus = "Musica"
	add_child(stream_player_2)
	
	stream_player_actual = stream_player_1
	stream_player_no_actual = stream_player_2
	
	tween = Tween.new()
	add_child(tween)
	
	is_ready = true


func _process(delta):
	return
	DebugDraw.set_text("track", Tracks.keys()[track_actual])
	DebugDraw.set_text("play1", str(stream_player_1.get_playback_position()) + (" - ") + str(stream_player_1.get_stream_playback()))
	DebugDraw.set_text("play2", str(stream_player_2.get_playback_position()) + (" - ") + str(stream_player_2.get_stream_playback()))
	DebugDraw.set_text("objetivo_actual", objetivo_actual)


func asignar_musica(cancion_res : ResCancion):
	musica = cancion_res
	if cancion_res == null: return
	cambiar_musica(track_actual)


func crossfade(nueva_cancion : AudioStream, posicion : float):
	var VOL_SILENCIO := -40.0
	var VOL_NORMAL := 0.0
	var DURACION := 0.5
	objetivo_actual = nueva_cancion
	
	var no_player = stream_player_no_actual
	no_player.stream = nueva_cancion
	no_player.play()
	no_player.seek(posicion)
	
	tween.interpolate_property(
		no_player,
		"volume_db",
		VOL_SILENCIO,
		VOL_NORMAL,
		DURACION,
		Tween.TRANS_LINEAR
	)
	
	tween.interpolate_property(
		stream_player_actual,
		"volume_db",
		VOL_NORMAL,
		VOL_SILENCIO,
		DURACION,
		Tween.TRANS_LINEAR,
		2,
		DURACION
	)
	
	tween.start()
	
	stream_player_no_actual = stream_player_actual
	stream_player_actual = no_player


func tomar_player_no_usado() -> AudioStreamPlayer:
	if stream_player_actual == stream_player_1:
		return stream_player_2
	else:
		return stream_player_1


func cambiar_musica(track : int):
	if !is_ready: yield(self, "ready")
	
	var track_viejo = track_actual
	track_actual = track
	
	var objetivo : AudioStream
	var pos_vieja : float
	if stream_player_actual:
		pos_vieja = stream_player_actual.get_playback_position()
	
	if musica != null:
		match track:
			Tracks.MUS_MENU:
				return
			Tracks.MUS_NORMAL:
				objetivo = musica.mus_normal
			Tracks.MUS_COMBATE:
				objetivo = musica.mus_combate
			_:
				return
	
	if objetivo != objetivo_actual:
		crossfade(objetivo, pos_vieja)



