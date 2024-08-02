extends Node2D

var dialogs : Array = []

func _ready():
	for child in $Dialogs.get_children():
		if child is DialogBubble:
			dialogs.append(child)
	
	$AnimationPlayer.play("Start")
	Game.respawnScene = ""
	MainAreaMusic.stop()

var currDialogIndex = 0
func nextDialog():
	if currDialogIndex == 3:
		$CutsceneSprite.play("GunpointMad")
	if currDialogIndex == 10:
		$CutsceneSprite.play("Delete")
		$Delete.play()
	if currDialogIndex == 13:
		$CutsceneSprite.play("TurnAround")
		$LabCoatRustle.play()
	if currDialogIndex == 22:
		$CutsceneSprite.play("Shoot")
		$Shoot.play()
	if currDialogIndex == 26:
		finshed = true
		$AnimationPlayer.play("CutsceneOver")
	
	if currDialogIndex -1 >= 0:
		dialogs[currDialogIndex - 1].finish()
	if currDialogIndex > dialogs.size() -1:
		return
	dialogs[currDialogIndex].initialize()
	currDialogIndex += 1

var started = false
var finshed = false
func start():
	if !started:
		nextDialog()
		started = true

func _process(_delta):
	if Input.is_action_just_released("Interact") and started == true and finshed == false:
		nextDialog()


func _on_cutscene_sprite_animation_finished():
	if $CutsceneSprite.animation == "Delete":
		$CutsceneSprite.play("GunpointMad")
	elif $CutsceneSprite.animation == "TurnAround":
		$CutsceneSprite.play("TurnIdle")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "CutsceneOver":
		Game.switchSceneNoData("res://UI/MainMenu/main_menu.tscn")
