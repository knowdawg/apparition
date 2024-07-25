extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Pulsate")
	$Settings.visible = false
	$Options.visible = true
	
	Game.loadSave()
	$Options/HBoxContainer/Continiue.disabled = !Game.respawnScene
	
	$Options/HBoxContainer/Continiue.grab_focus()
	
	$Settings/VBoxContainer/Volume.value = Game.masterVolume * 100.0
	$Settings/VBoxContainer/Effects.value = Game.soundEfectsVolume * 100.0
	$Settings/VBoxContainer/Music.value = Game.musicVolume * 100.0
	
	$Music.playSound()



func _on_settings_pressed():
	$Settings.visible = true
	$Options.visible = false
	$Settings/VBoxContainer/Back.grab_focus()


func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$Settings.visible = false
	$Options.visible = true
	$Options/HBoxContainer/Continiue.grab_focus()

func _on_start_new_game_pressed():
	$Settings.visible = false
	
	Game.createNewSave()
	Game.loadSave()
	var s = SwitchSceneData.new()
	s.scene = "res://Levels/TutorialArea/starting_level.tscn"
	s.door = "Spawn"
	s.facingLeft = false
	Game.switch_scene(s)


func _on_continiue_pressed():
	$Settings.visible = false
	
	Game.loadSave()
	Game.playerDead()


func _on_volume_value_changed(value):
	Game.masterVolume = value / 100.0

func _on_effects_value_changed(value):
	Game.soundEfectsVolume = value / 100.0

func _on_music_value_changed(value):
	Game.musicVolume = value / 100.0
