extends AudioStreamPlayer

var playback: AudioStreamPlaybackPolyphonic:
	get: return get_stream_playback()

@onready var animator: AnimationPlayer = %AnimationPlayer

@onready var music_manager: AudioStreamPlayer = %MusicManager
