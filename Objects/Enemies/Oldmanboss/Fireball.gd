extends State
class_name BossFireball

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var projectileSpawnPoint : Marker2D

func update(_delta):
	pass

func fire():
	var offset = randf_range(-5, 5) - 30
	for i in 3:
		var target_pos = Game.player.global_position + Vector2(0, offset)
		var dir = (target_pos - projectileSpawnPoint.global_position).normalized()
		parent.fireProjectile(dir, 200)
		offset += 30

func fire2():
	if parent.phase == 2:
		var offset = -15
		for i in 2:
			var target_pos = Game.player.global_position + Vector2(0, offset)
			var dir = (target_pos - projectileSpawnPoint.global_position).normalized()
			parent.fireProjectile(dir, 200)
			offset += 30

func fire3():
	if parent.phase == 2:
		var offset = randf_range(-5, 5) - 30
		for i in 2:
			var target_pos = Game.player.global_position + Vector2(0, offset)
			var dir = (target_pos - projectileSpawnPoint.global_position).normalized()
			parent.fireProjectile(dir, 200)
			offset += 60

func enter():
	spriteAnimator.play("Fireball")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fireball":
		trasitioned.emit(self, "Idle")
