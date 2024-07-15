extends State
class_name BossSitting

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("RESET")

func stand():
	spriteAnimator.play("StandUp")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "StandUp":
		trasitioned.emit(self, "Idle")
