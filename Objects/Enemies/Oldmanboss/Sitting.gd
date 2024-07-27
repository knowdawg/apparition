extends State
class_name BossSitting

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var dialog : Node
@export var reapeatDialog : Node

func update(_delta):
	pass

func enter():
	spriteAnimator.play("RESET")

func stand():
	if Game.bossDialogFirstTime == true:
		dialog.start()
		Game.bossDialogFirstTime = false
	else:
		reapeatDialog.start()

func cutsceneDone():
	trasitioned.emit(self, "Idle")
