extends State
class_name BossPhaseTransition

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("PhaseTransition")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "PhaseTransition":
		trasitioned.emit(self, "CrazyCombo")
