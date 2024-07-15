extends State
class_name BossProjectiles

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(delta):
	print("PROJEC")
	trasitioned.emit(self, "Idle")

func enter():
	spriteAnimator.play("Idle")
