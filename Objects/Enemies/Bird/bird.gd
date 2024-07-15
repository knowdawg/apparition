extends Enemy
class_name Bird

var projectile = preload("res://Objects/Projectiles/BirdProjectile/bird_projectile.tscn")

var MAX_MOVEMENT_SPEED = 40.0
var movementSpeed = 200

@export var bashShield = false

@onready var stateMachine = $StateMachine
@onready var sprite = $BirdSprite

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
	
	bash_going = true

func bash_complete():
	sprite.visible = false
	
var bash_going = false
func _process(_delta):
	bashShield = bashShieldComponent.getShield()
	if bash_going:
		sprite.look_at(get_global_mouse_position())

func move(towardsPlayer : bool, delta):
	var motion = (global_position - Game.player.global_position).normalized() * movementSpeed * delta
	if towardsPlayer == true:
		motion *= -1.0
	velocity += motion
	
	if velocity.length() > MAX_MOVEMENT_SPEED:
		velocity = velocity.normalized() * MAX_MOVEMENT_SPEED
	if velocity.length() < -MAX_MOVEMENT_SPEED:
		velocity = velocity.normalized() * MAX_MOVEMENT_SPEED * -1.0

func _physics_process(_delta):
	if healthComponent.get_health() <= 0.0:
		velocity = lerp(velocity, Vector2.ZERO, 0.1)
	
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	knockback = lerp(knockback, Vector2.ZERO, 0.2)
	velocity += knockback
	move_and_slide()
	velocity -= knockback

func align(player : Player):
	if player.global_position > global_position:
		sprite.flip_h = true
	elif player.global_position < global_position:
		sprite.flip_h = false

func arrow_attack(dir : Vector2):
	var p = projectile.instantiate()
	p.initialize(dir)
	Game.currentLevel.add_projectile(p)
	p.position = global_position

func hit(attack : Attack):
	do_hit_effect(attack)
	
	if attack.is_bash_attack and bashShieldComponent.getShield():
		bashShieldComponent.setShield(false)
	
	var currentState = stateMachine.current_state
	if currentState.has_method("hit"):
		currentState.hit(attack)
		
func do_hit_effect(attack):
	
	if attack.attack_damage > 0.0:
		$Components/HitAnimator.play("Hit")
		$Components/EnemyHitEffectComponent.hit()
	
	velocity = Vector2.ZERO
	knockback = (global_position - attack.attack_position).normalized() * attack.knockback_force
	
	if attack.attack_position > global_position:
		$Components/HitParticles.rotation_degrees = 180.0
	elif attack.attack_position < global_position:
		$Components/HitParticles.rotation_degrees = 0.0

func death(attack : Attack):
	hit(attack)
	dead.emit(self)
	
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	stateMachine.onChildTransition(stateMachine.current_state, "Death")
	$Components/EnemyDeathEffectComponent.die()
	$Components/HurtboxComponent.call_deferred("disable")
	bashComponent.call_deferred("activate")
	
