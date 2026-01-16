extends AudioStreamPlayer

var playback: AudioStreamPlaybackPolyphonic:
	get: return get_stream_playback()


func _ready() -> void:
	stream = AudioStreamPolyphonic.new()
	bus = "UI"
	max_polyphony = stream.polyphony
	play()
