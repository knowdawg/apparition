extends State
class_name BossCrazyCombo

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var leftBoundry : Marker2D
@export var rightBoundry : Marker2D
@export var projectileSpawnPoint : Marker2D
@export var sprite : Sprite2D

var dashTarget
func update(delta):
	if t > 0:
		parent.position.x = lerp(parent.position.x, dashTarget, 0.07)
	t -= delta

func enter():
	spriteAnimator.play("CrazyCombo")

func teleport():
	var loc = randf_range(leftBoundry.position.x, rightBoundry.position.x)
	parent.position.x = loc

func teleportToPlayer():
	var loc = Game.player.global_position.x
	if randi_range(0, 1) == 0:
		loc -= 10
	else:
		loc += 10
	parent.position.x = loc

func teleportAwayFromPlayer():
	var loc
	var leftDis = leftBoundry.position.distance_to(Game.player.global_position)
	var rightDis = rightBoundry.position.distance_to(Game.player.global_position)
	if leftDis > rightDis:
		loc = leftBoundry.position
	else:
		loc = rightBoundry.position
	parent.position.x = loc.x

func fireX():
	parent.fireProjectile(Vector2(1.0,0.5).normalized(), 200)
	parent.fireProjectile(Vector2(-1.0,0.5).normalized(), 200)
	parent.fireProjectile(Vector2(1.0,-0.5).normalized(), 200)
	parent.fireProjectile(Vector2(-1.0,-0.5).normalized(), 200)

func fireCross():
	var offset = randf_range(-0.05, 0.0)
	parent.fireProjectile(Vector2(1, offset).normalized(), 200)
	parent.fireProjectile(Vector2(-1, offset).normalized(), 200)
	parent.fireProjectile(Vector2(0,-1), 200)
	parent.fireProjectile(Vector2(0,1), 200)
	parent.fireProjectile(Vector2(1,1).normalized(), 200)
	parent.fireProjectile(Vector2(-1,1).normalized(), 200)
	parent.fireProjectile(Vector2(-1,-1).normalized(), 200)
	parent.fireProjectile(Vector2(1,-1).normalized(), 200)

func fireShotgun1():
	var offset = randf_range(-5, 5) - 30
	for i in 3:
		var target_pos = Game.player.global_position + Vector2(0, offset)
		var dir = (target_pos - projectileSpawnPoint.global_position).normalized()
		parent.fireProjectile(dir, 200)
		offset += 30

func fireShotgun2():
	var offset = -15
	for i in 2:
		var target_pos = Game.player.global_position + Vector2(0, offset)
		var dir = (target_pos - projectileSpawnPoint.global_position).normalized()
		parent.fireProjectile(dir, 200)
		offset += 30

var t : float = 0.0
func dash():
	parent.align()
	t = 1.0
	if sprite.flip_h:
		dashTarget = Game.player.global_position.x + randi_range(16, 32)
	else:
		dashTarget = Game.player.global_position.x - randi_range(16, 32)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "CrazyCombo":
		trasitioned.emit(self, "Snap")
