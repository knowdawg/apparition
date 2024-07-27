extends State
class_name BossSitting

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var dialog : Node

func update(_delta):
	pass

func enter():
	spriteAnimator.play("RESET")

func stand():
	dialog.start()

func cutsceneDone():
	trasitioned.emit(self, "Idle")
