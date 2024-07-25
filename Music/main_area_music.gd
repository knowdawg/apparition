extends Node

@export var vol : float

var combat = false
var combatVolumeMultiplier = -100.0

func _process(delta):
	$Music.volume_db = Game.get_volume(false) + vol
	$Combat.volume_db = Game.get_volume(false) + combatVolumeMultiplier + vol -5
	
	if combat:
		combatVolumeMultiplier += 100 * delta
	else:
		combatVolumeMultiplier -= 30 * delta
	combatVolumeMultiplier = clamp(combatVolumeMultiplier, -100, 0.0)

func play():
	if $Music.playing == false:
		$Music.play()
		$Combat.play()

func stop():
	$Music.stop()
	$Combat.stop()

func _on_music_finished():
	$Music.play()
	$Combat.play()
