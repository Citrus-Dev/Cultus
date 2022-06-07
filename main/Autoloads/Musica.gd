extends Node

enum Tracks {
	MUS_MENU,
	MUS_NORMAL,
	MUS_COMBATE
}
var track_actual : int setget cambiar_musica

var musica : ResCancion

var stream_player_1 : AudioStreamPlayer
var stream_player_2 : AudioStreamPlayer
var stream_player_actual : AudioStreamPlayer
var tween : Tween

func _ready():
	stream_player_1 = AudioStreamPlayer.new()
	stream_player_1.bus = "Musica"
	add_child(stream_player_1)
	
	stream_player_2 = AudioStreamPlayer.new()
	stream_player_2.bus = "Musica"
	add_child(stream_player_2)
	
	stream_player_actual = stream_player_1
	
	tween = Tween.new()
	add_child(tween)


func _process(delta):
	DebugDraw.set_text("track", Tracks.keys()[track_actual])
	print(stream_player_1.volume_db)
	print(stream_player_2.volume_db)


func asignar_musica(cancion_res : ResCancion):
	if cancion_res == null: return
	musica = cancion_res
	cambiar_musica(track_actual)


func crossfade(nueva_cancion : AudioStream, posicion : float):
	var VOL_SILENCIO := -40.0
	var VOL_NORMAL := 0.0
	var DURACION := 0.5
	
	var stream_player_no_actual := tomar_player_no_usado()
	stream_player_no_actual.stream = nueva_cancion
	stream_player_no_actual.play()
	stream_player_no_actual.seek(posicion)
	
	tween.interpolate_property(
		stream_player_no_actual,
		"volume_db",
		VOL_SILENCIO,
		VOL_NORMAL,
		DURACION,
		Tween.TRANS_LINEAR
	)
	
	tween.start()
	
	tween.interpolate_property(
		stream_player_actual,
		"volume_db",
		VOL_NORMAL,
		VOL_SILENCIO,
		DURACION,
		Tween.TRANS_LINEAR
	)
	
	tween.start()


func tomar_player_no_usado() -> AudioStreamPlayer:
	if stream_player_actual == stream_player_1:
		return stream_player_2
	else:
		return stream_player_1


func cambiar_musica(track : int):
	track_actual = track
	if musica == null: return
	
	var objetivo : AudioStream
	var pos_vieja : float = stream_player_actual.get_playback_position()
	match track:
		Tracks.MUS_MENU:
			return
		Tracks.MUS_NORMAL:
			objetivo = musica.mus_normal
		Tracks.MUS_COMBATE:
			objetivo = musica.mus_combate
		_:
			return
	
	crossfade(objetivo, pos_vieja)



