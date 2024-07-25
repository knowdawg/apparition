extends State
class_name BossGroundSlam

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var sound : SoundPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("GroundSlam")

func fire():
	sound.playSound()
	var offset = randf_range(-0.05, 0.0)
	parent.fireProjectile(Vector2(1, offset).normalized(), 200)
	parent.fireProjectile(Vector2(-1, offset).normalized(), 200)
	parent.fireProjectile(Vector2(0,-1), 200)
	parent.fireProjectile(Vector2(0,1), 200)
	
	if parent.phase == 2:
		parent.fireProjectile(Vector2(1,1).normalized(), 200)
		parent.fireProjectile(Vector2(-1,1).normalized(), 200)
		parent.fireProjectile(Vector2(-1,-1).normalized(), 200)
		parent.fireProjectile(Vector2(1,-1).normalized(), 200)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GroundSlam":
		trasitioned.emit(self, "Idle")
