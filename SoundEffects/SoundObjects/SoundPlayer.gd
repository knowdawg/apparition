extends AudioStreamPlayer2D
class_name SoundPlayer

@export var volumeAdd = 0.0
@export var isSoundEffect = true

func playSound(pitchLow : float = 1.0, pitchHigh : float = 1.0):
	pitch_scale = randf_range(pitchLow, pitchHigh)
	volume_db = volumeAdd + Game.get_volume(isSoundEffect)
	play()
