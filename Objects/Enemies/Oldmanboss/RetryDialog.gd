extends Node

@export var animator : AnimationPlayer
@export var sitState : Node
@export var promp : NinePatchRect

var dialogs : Array = []

func _ready():
	for child in get_children():
		if child is DialogBubble:
			dialogs.append(child)
	promp.visible = false

var currDialogIndex = 0
func nextDialog():
	if currDialogIndex == 0:
		animator.play("StandUp")
	
	if currDialogIndex == 1:
		sitState.cutsceneDone()
		Game.player.setCutsceneMode(false)
		promp.visible = false
	
	if currDialogIndex -1 >= 0:
		dialogs[currDialogIndex - 1].finish()
	if currDialogIndex > dialogs.size() -1:
		return
	dialogs[currDialogIndex].initialize()
	currDialogIndex += 1

var started = false
func start():
	if !started:
		nextDialog()
		Game.player.setCutsceneMode(true)
		started = true
		promp.visible = true

func _process(_delta):
	if Input.is_action_just_released("Interact") and started == true:
		nextDialog()
