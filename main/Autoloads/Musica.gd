extends Node

const MENU_TRACK := preload("res://assets/musica/The-fire-is-gone.mp3")

enum Tracks {
	MUS_MENU = 0,
	MUS_NORMAL = 1,
	MUS_COMBATE = 2,
	SIN_MUSICA = 3
}
var track_actual : int setget set_track
var objetivo_actual : AudioStream

var musica : ResCancion

var stream_player_1 : AudioStreamPlayer
var stream_player_2 : AudioStreamPlayer
var stream_player_actual : AudioStreamPlayer
var stream_player_no_actual : AudioStreamPlayer
var tween : Tween

var is_ready : bool
# Forzar la musica a permanecer en un estado especifico. -1 para deactivar
var override : int = -1 setget set_override
var instantaneo: bool

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
	DebugDraw.set_text("vol1", stream_player_1.volume_db)
	DebugDraw.set_text("vol2", stream_player_2.volume_db)


func set_override(value : int):
	override = value
	cambiar_musica(track_actual if override == -1 else override)


func set_track(value : int):
	if track_actual == value: return
	track_actual = value
	cambiar_musica(track_actual if override == -1 else override)


func asignar_musica(cancion_res : ResCancion):
	musica = cancion_res
	if cancion_res == null: return
	cambiar_musica(track_actual)


func crossfade(nueva_cancion : AudioStream, posicion : float, instant: bool = instantaneo):
	
	var VOL_SILENCIO := -40.0
	var VOL_NORMAL := 0.0
	var DURACION := 0.5
	objetivo_actual = nueva_cancion
	
	var no_player = stream_player_no_actual
	no_player.stream = nueva_cancion
	no_player.play()
	no_player.seek(posicion)
	
	print("silenciando " + str(stream_player_actual.name) + ", subiendo " + str(stream_player_no_actual.name))
	
	if instant:
		no_player.volume_db = VOL_NORMAL
		stream_player_actual.volume_db = VOL_SILENCIO
	else:
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
			DURACION # Delay
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
	
	if track_actual == track_viejo: return
	
	var objetivo : AudioStream
	var pos_vieja : float
	if stream_player_actual:
		pos_vieja = stream_player_actual.get_playback_position()
	
	match track:
		Tracks.MUS_MENU:
			objetivo = MENU_TRACK
		Tracks.MUS_NORMAL:
			if musica != null:
				objetivo = musica.mus_normal
		Tracks.MUS_COMBATE:
			if musica != null:
				objetivo = musica.mus_combate
		Tracks.SIN_MUSICA:
			objetivo = null
		_:
			return
	
	if objetivo != objetivo_actual:
		crossfade(objetivo, pos_vieja)


func hacer_sonido(stream : AudioStream, pos : Vector2, vol_over := 0.0, usar_2d := true):
	var nivel = get_tree().root
	var snd = Sonido.new(stream, vol_over, usar_2d)
	if usar_2d: snd.global_position = pos
	nivel.add_child(snd)


func reiniciar_musica():
	stream_player_1.play(0.0)
	stream_player_2.play(0.0)
