extends State
class_name PlayerAttack2

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player
@export var Hitbox : HitboxComponent
@export var sound : AudioStreamPlayer2D

var animation_cancel_timer = 0.4

func update(delta):
	player.update_physics(delta)
	
	if Input.is_action_just_pressed("Jump"):
		player.jump(delta)
		trasitioned.emit(self, "Jump")
		return
	if Input.is_action_pressed("Bash") or player.getRightStickStrength():
		var bashTarget = player.bashProximity.get_bash_target()
		if bashTarget:
			player.bashSetup(bashTarget)
			trasitioned.emit(self, "Bash")
		
	animation_cancel_timer -= delta
	if animation_cancel_timer <= 0.0:
		Hitbox.collisionShape.disabled = true
		
		if Input.is_action_pressed("Attack"):
			trasitioned.emit(self, "Attack1")
			return
		if abs(player.velocity.x) > 5.0:
			trasitioned.emit(self, "Run")
			return
	elif animation_cancel_timer <= 0.35 and animation_cancel_timer >= 0.2:
		Hitbox.collisionShape.disabled = false
	else:
		Hitbox.collisionShape.disabled = true
		
func enter():
	animated_player_sprite.play("Attack2")
	animation_cancel_timer = 0.4
	sound.playSound(3.0, 4.0)
	Hitbox.generateAttackID()
	player.align()

func exit(_newState):
	Hitbox.call_deferred("disable")
