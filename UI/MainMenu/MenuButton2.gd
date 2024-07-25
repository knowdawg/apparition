extends Button

func _on_mouse_entered():
	$SoundPlayer.playSound(0.8 , 1.2)

func _on_pressed():
	$SoundPlayer2.playSound()

func _on_focus_entered():
	$SoundPlayer.playSound(0.8 , 1.2)
