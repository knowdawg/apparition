extends Node

@export var animator : AnimationPlayer
@export var sitState : Node

var dialogs : Array = []

func _ready():
	for child in get_children():
		if child is DialogBubble:
			dialogs.append(child)

var currDialogIndex = 0
func nextDialog():
	if currDialogIndex == 11:
		animator.play("StandUp")
	
	if currDialogIndex == 14:
		sitState.cutsceneDone()
		Game.player.setCutsceneMode(false)
	
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

func _process(_delta):
	if Input.is_action_just_released("Interact") and started == true:
		nextDialog()
