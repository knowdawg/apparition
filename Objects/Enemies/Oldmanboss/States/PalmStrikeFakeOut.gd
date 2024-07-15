extends State
class_name BossPalmStrikeFakeOut

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("PalmStrikeFakeOut")

func teleport():
	parent.position.x = 0

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "PalmStrikeFakeOut":
		trasitioned.emit(self, "Idle")
