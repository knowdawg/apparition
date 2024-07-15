extends State
class_name BossDead

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("Death")
