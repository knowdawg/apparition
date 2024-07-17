extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Pulsate")
	$Settings.visible = false
	$Options.visible = true
	
	Game.loadSave()
	$Options/HBoxContainer/Continiue.disabled = !Game.respawnScene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	$Settings.visible = true
	$Options.visible = false


func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$Settings.visible = false
	$Options.visible = true

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
