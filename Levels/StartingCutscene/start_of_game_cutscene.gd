extends Node2D

var dialogs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Animate")
	$Grass/ParallaxLayer/Grass.play("default")
	for child in $Text.get_children():
		dialogs.append(child)
	Game.playerSpawnForFirstTime = true
	
	for child in $GrassBackgroudn/ParallaxLayer.get_children():
		child.play("default")
	
	$IntroSound.volume_db = Game.get_volume(true)
	$IntroSound.play()

var currDialogIndex = 0
func nextDialog():
	if currDialogIndex -1 >= 0:
		dialogs[currDialogIndex - 1].playingInside = false
	if currDialogIndex > dialogs.size() -1:
		return
	dialogs[currDialogIndex].playingInside = true
	currDialogIndex += 1

func startGame():
	var s = SwitchSceneData.new()
	s.scene = "res://Levels/TutorialArea/starting_level.tscn"
	s.door = "Spawn"
	s.facingLeft = false
	Game.switch_scene(s)


var numOfSkips = 0
func _process(_delta):
	if Input.is_action_just_pressed("Menu"):
		numOfSkips += 1
		$SKipCutscene.visible = true
		if numOfSkips >= 2:
			startGame()
