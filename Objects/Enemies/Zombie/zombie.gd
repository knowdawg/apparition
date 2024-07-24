extends Enemy
class_name Zombie

@export var bashShield = false

@export var MAX_SPEED : float = 4000.0
var gravity : float = 700.0

@onready var sprite = $AnimatedSprite2D
@onready var hitParticles = $HitParticles
@onready var stateMachine : ZombieStateMachine = $StateMachine
@onready var bashShieldComponent : BashShieldComponent = $BashShieldComponent

func bash():
	sprite.play("Bash")
	z_index = 10

func bash_complete():
	sprite.visible = false
	
	#queue_free()

func _process(_delta):
	bashShield = bashShieldComponent.getShield()

func update_physics(delta):
	velocity.x = lerpf(velocity.x, 0, 0.4)
	velocity.y += gravity * delta
	move_and_slide()

func check_for_jump():
	if is_on_wall() and is_on_floor():
		velocity.y = -175

func move(movementSpeedMultiplier : float, delta):
	if sprite.flip_h == true:
		velocity.x = MAX_SPEED * movementSpeedMultiplier * delta
	elif sprite.flip_h == false:
		velocity.x = -MAX_SPEED * movementSpeedMultiplier * delta

func align(player : Player):
	if player.global_position > global_position:
		sprite.flip_h = true
		$HitboxComponent.scale.x = -1.0
		
	elif player.global_position < global_position:
		sprite.flip_h = false
		$HitboxComponent.scale.x = 1.0

func _ready():
	$AnimatedSprite2D.play("Idle")
	MAX_SPEED *= randf_range(0.9, 1.1)
	
	if bashShield:
		bashShieldComponent.setShield(bashShield)

func hit(attack : Attack):
	do_hit_effect(attack)
	
	if attack.is_bash_attack and bashShieldComponent.getShield():
		bashShieldComponent.setShield(false)
	
	var currentState = stateMachine.current_state
	if currentState.has_method("hit"):
		currentState.hit(attack)

func do_hit_effect(attack: Attack):
	if attack.attack_damage > 0.0:
		$HitAnimator.play("Hit")
		$EnemyHitEffectComponent.hit()
		$HitSound.play()
	
	velocity.x = (global_position - attack.attack_position).normalized().x * attack.knockback_force
	
	if attack.attack_position > global_position:
		$HitParticles.rotation_degrees = 180.0
	elif attack.attack_position < global_position:
		$HitParticles.rotation_degrees = 0.0
	

func death(attack : Attack):
	hit(attack)
	dead.emit(self)
	
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	velocity *= 3.0
	
	if attack.attack_position > global_position:
		sprite.flip_h = true
		$BashComponent.position.x = -5
	elif attack.attack_position < global_position:
		sprite.flip_h = false
		$BashComponent.position.x = 5
	
	$EnemyDeathEffectComponent.die()
	$AnimatedSprite2D.play("Death")
	stateMachine.onChildTransition(stateMachine.current_state, "Dead")
	$HurtboxComponent.call_deferred("disable")
	
	$BashComponent.call_deferred("activate")


func _on_hazard_checker_area_entered(_area):
	var a = Attack.new()
	a.attack_damage = 10
	a.knockback_force = 0.0
	a.attack_position = Vector2.ZERO
	$HealthComponent.damage(a)
