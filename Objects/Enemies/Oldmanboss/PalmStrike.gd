extends State
class_name BossPalmStrike

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var sprite : Sprite2D
@export var leftLoc : Marker2D
@export var rightLoc : Marker2D

var target
var r = 1

func update(_delta):
	if r == 0:
		trasitioned.emit(self, "PalmStrikeFakeOut")
	
func teleport():
	parent.position = target

func enter():
	r = randi_range(0, 3)
	
	spriteAnimator.play("PalmStrike")
	
	if sprite.flip_h:
		target = rightLoc.global_position
	else:
		target = leftLoc.global_position


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "PalmStrike":
		trasitioned.emit(self, "Idle")
