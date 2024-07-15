extends State
class_name BossTeleport

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var leftBoundry : Marker2D
@export var rightBoundry : Marker2D

var numOfTeleports = 0

func update(_delta):
	pass

func enter():
	numOfTeleports = randi_range(1, 3)
	if numOfTeleports > 1: #66% chance for 1, 33% chance for 2
		numOfTeleports -= 1
	spriteAnimator.play("Teleport")

func teleport():
	var loc = randf_range(leftBoundry.position.x, rightBoundry.position.x)
	parent.position.x = loc

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Teleport":
		numOfTeleports -= 1
		if numOfTeleports <= 0:
			trasitioned.emit(self, "Idle")
		else:
			spriteAnimator.play("Teleport")
