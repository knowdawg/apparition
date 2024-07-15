extends State
class_name BossUppercut

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func fire():
	parent.fireProjectile(Vector2(1.0,0.5).normalized(), 200)
	parent.fireProjectile(Vector2(-1.0,0.5).normalized(), 200)
	parent.fireProjectile(Vector2(1.0,-0.5).normalized(), 200)
	parent.fireProjectile(Vector2(-1.0,-0.5).normalized(), 200)

func fire2():
	if parent.phase == 2:
		var offset = randf_range(-0.05, 0.0)
		parent.fireProjectile(Vector2(1, offset).normalized(), 200)
		parent.fireProjectile(Vector2(-1, offset).normalized(), 200)
		parent.fireProjectile(Vector2(0,-1), 200)
		parent.fireProjectile(Vector2(0,1), 200)

func update(_delta):
	pass

func enter():
	spriteAnimator.play("Uppercut")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Uppercut":
		trasitioned.emit(self, "Idle")
