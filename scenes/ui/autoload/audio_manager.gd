extends AudioStreamPlayer

var playback: AudioStreamPlaybackPolyphonic:
	get: return get_stream_playback()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = AudioStreamPolyphonic.new()
	bus = "UI"
	max_polyphony = stream.polyphony
	volume_db = -30.
	play()
