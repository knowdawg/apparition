extends Enemy
class_name Reaper

@export var bashShield = false

@onready var MAX_MOVEMENT_SPEED = 40.0 * randf_range(0.9, 1.1)
var movementSpeed = 200

@onready var stateMachine = $StateMachine
@onready var sprite = $ReaperSprite
@onready var healthComponent : HealthComponent = $Components/HealthComponent
@onready var bashComponent = $Components/BashComponent
@onready var bashShieldComponent : BashShieldComponent = $Components/BashShieldComponent

var knockback = Vector2.ZERO

func _ready():
	if bashShield:
		bashShieldComponent.setShield(bashShield)

func bash():
	z_index = 10
	sprite.play("Bash")
	sprite.offset = Vector2(0.0, -0.5)

func bash_complete():
	sprite.visible = false

func move(towardsPlayer : bool, delta):
	var motion = Vector2(movementSpeed * delta, 0.0)
	if Game.player.global_position >= global_position:
		motion *= -1.0
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if towardsPlayer == true:
		motion *= -1.0
		
	if Game.player.global_position.y >= global_position.y:
		motion.y += 100 * delta
	else:
		motion.y -= 100 * delta
	
	velocity += motion
	
	if velocity.length() > MAX_MOVEMENT_SPEED:
		velocity = velocity.normalized() * MAX_MOVEMENT_SPEED
	if velocity.length() < -MAX_MOVEMENT_SPEED:
		velocity = velocity.normalized() * MAX_MOVEMENT_SPEED * -1.0

func _process(_delta):
	bashShield = bashShieldComponent.getShield()

func _physics_process(_delta):
	knockback = lerp(knockback, Vector2.ZERO, 0.3)
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	velocity += knockback
	move_and_slide()
	velocity -= knockback

func align(player : Player):
	if player.global_position > global_position:
		sprite.flip_h = true
	elif player.global_position < global_position:
		sprite.flip_h = false

func hit(attack : Attack):
	do_hit_effect(attack)
	if attack.is_bash_attack and bashShieldComponent.getShield():
		bashShieldComponent.setShield(false)
		
	var currentState = stateMachine.current_state
	if currentState.has_method("hit"):
		currentState.hit(attack)
		
func do_hit_effect(attack : Attack):
	if attack.attack_damage > 0.0:
		$Components/HitAnimator.play("Hit")
		$Components/EnemyHitEffectComponent.hit()
		$HitSound.playSound(0.75, 1.5)
		$HitSound2.playSound(1.0, 1.5)
	
	velocity = Vector2.ZERO
	knockback = (global_position - attack.attack_position).normalized() * attack.knockback_force
	knockback.y = 0.0
	
	if attack.attack_position > global_position:
		$Components/HitParticles.rotation_degrees = 180.0
	elif attack.attack_position < global_position:
		$Components/HitParticles.rotation_degrees = 0.0
	
func death(attack : Attack):
	hit(attack)
	dead.emit(self)
	
	set_collision_mask_value(1, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	stateMachine.onChildTransition(stateMachine.current_state, "Death")
	$Components/EnemyDeathEffectComponent.die()
	$Components/HurtboxComponent.call_deferred("disable")
	$Components/HitboxComponent.call_deferred("disable")
	bashComponent.call_deferred("activate")
	$HitSound2.playSound(1.0, 1.0)
	
