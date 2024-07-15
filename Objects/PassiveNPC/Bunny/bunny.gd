extends Enemy


const SPEED = 1200.0
const JUMP_VELOCITY = -30.0

var jumping = false
var dir = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Timer.start(randf_range(1.0, 3.0))

func _physics_process(delta):
	if dir == -1:
		$AnimatedSprite2D.flip_h = false
	elif dir == 1:
		$AnimatedSprite2D.flip_h = true
	
	if not is_on_floor():
		velocity.y += gravity * delta * 0.3
	
	if $AnimatedSprite2D.animation == "Jump":
		velocity.x = SPEED * delta * dir
	else:
		velocity.x = lerpf(velocity.x, 0, 0.15)
		
	move_and_slide()

func jump():
	velocity.y += JUMP_VELOCITY


func death(_attack):
	$AnimatedSprite2D.play("Death")
	$Timer.queue_free()
	$AnimatedSprite2D/HitFlashComponent.flash()
	$EnemyHitEffectComponent.hit()
	$HitParticles.emitting = true
	$HurtboxComponent.call_deferred("disable")

func _on_timer_timeout():
	if jumping == false and is_on_floor():
		jumping = true
		$AnimatedSprite2D.play("Jump")
		$JumpDelay.start()
		$Timer.start(randf_range(1.0, 3.0))
	else:
		jumping = false
		$Timer.start(randf_range(1.0, 6.0))
	

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Death":
		return
	
	if jumping == true:
		$AnimatedSprite2D.play("Jump")
		$JumpDelay.start()
	else:
		$AnimatedSprite2D.play("Idle")
		if randf_range(0, 5) < 1:
			dir *= -1

func _on_jump_delay_timeout():
	jump()
