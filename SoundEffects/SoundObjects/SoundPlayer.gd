extends AudioStreamPlayer2D
class_name SoundPlayer

@export var volumeAdd = 0.0
@export var isSoundEffect = true
@export var canBeSlowed = true

var pitch = 1.0
func playSound(pitchLow : float = 1.0, pitchHigh : float = 1.0):
	var p = randf_range(pitchLow, pitchHigh)
	pitch_scale = p
	pitch = p
	volume_db = volumeAdd + Game.get_volume(isSoundEffect)
	play()

func _process(_delta):
	if canBeSlowed:
		var speedScale = Engine.time_scale
		pitch_scale = pitch * speedScale
