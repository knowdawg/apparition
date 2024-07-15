extends State
class_name BossDash

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var sprite : Sprite2D

var target

func update(_delta):
	parent.position.x = lerp(parent.position.x, target, 0.07)

func enter():
	parent.align()
	spriteAnimator.play("Dash")
	if sprite.flip_h:
		target = Game.player.global_position.x + randi_range(16, 32)
	else:
		target = Game.player.global_position.x - randi_range(16, 32)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Dash":
		trasitioned.emit(self, "Idle")
