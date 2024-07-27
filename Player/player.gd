extends CharacterBody2D
class_name Player

const GRAVITY = 1

var max_speed : float = 0.45 * 144 #first number is abmout of pixels per frame
var max_fall_speed : float = 2 * 144
var aceleration = 2000
var friction = 0.7

var jump_hieght : int = 34
var jump_distance : int = 26 #distance till peak of the jump
var jump_time : float = jump_distance/max_speed#57.6 #time to reach climax of jump
var gravity : float = (2 * jump_hieght)/(pow(jump_time,2))
var jump_force : float = (2 * jump_hieght)/jump_time

var coyote_time = false
var prejump = false
@export var prejumpTimer : Timer
@export var CoyoteTimer : Timer

@onready var sprite = $HeroSprite
@onready var hitbox = $HitboxComponent
@onready var stateMachine : PlayerStateMachine = $StateMachine
@onready var hurtbox = $HurtboxComponent
@onready var healthComponent : HealthComponent = $HealthComponent
@onready var bashProximity = $BashProximity

@onready var camera = $Camera2DPlus

var bashTargetPosition = Vector2.ZERO
var curBashTarget
var canHealFromBash = true
func bashSetup(bashTarget : BashComponent):
	velocity = Vector2.ZERO
	curBashTarget = bashTarget
	if !curBashTarget.bashComplete.is_connected(bashComplete):
		curBashTarget.bashComplete.connect(bashComplete)
	curBashTarget.bash()
	
	bashTargetPosition = curBashTarget.global_position
	
	canHealFromBash = bashTarget.oneShot #only heal if its a one time bash
	
	$BashSound.playSound()

func bashComplete():
	stateMachine.onChildTransition(stateMachine.current_state, "Stun")
	if Game.controler:
		currentKnockbackVector = getControllerBashVector() * -300.0
	else:
		currentKnockbackVector = (global_position - get_global_mouse_position()).normalized() * 300.0
	if curBashTarget.parrent is platformingBash:
		currentKnockbackVector *= 3.0
	curBashTarget = null
	
	if canHealFromBash == true:
		$HeroSprite/HealFlashComponent.flash()
		healthComponent.set_health(healthComponent.get_health() + 1.0)

func getControllerBashVector() -> Vector2:
	var stickVector = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), 
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)).normalized()
	return stickVector
	
func getRightStickStrength():
	var stickVector = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), 
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
	return stickVector.length() >= 0.8

func initialize(health : float, facingLeft : bool, isDead : bool = false, maxHealth : float = 10.0, weaponDamage : float = 1.0):
	healthComponent.set_max_health(maxHealth)
	healthComponent.set_health(health)
	hitbox.attack_damage = weaponDamage
	
	if facingLeft == true:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	
	if isDead:
		stateMachine.onChildTransition(stateMachine.current_state, "Getup")

func _ready():
	Game.player = self
	$UI/Control/HealthBarComponent.visible = true
	
	camera.position_smoothing_enabled = false
	$Timers/EnableSmoothCameraTimer.start()
	
	if Game.playerSpawnForFirstTime:
		Game.playerSpawnForFirstTime = false
		stateMachine.onChildTransition(stateMachine.current_state, "Getup")
		$FirstTimeWakeUp.playSound()

func _process(_delta):
	healthComponent.set_max_health(Game.maxPlayerHealth)
	hitbox.attack_damage = Game.playerDmg
	if Game.playerDmg > 1.0:
		$UI/Control/HealthBarComponent.upgradeSword()
	
	var c = $CameraProximityChecker.get_camera_bounds()
	if c:
		Game.currentCamera.limit_left = c.leftLimit
		Game.currentCamera.limit_right = c.rightLimit
		Game.currentCamera.limit_top = c.upLimit
		Game.currentCamera.limit_bottom = c.downLimit

var wasOnFloor = true
func update_physics(delta):
	
	if is_on_floor() == true and wasOnFloor == false:
		$HitGroundSound.playSound(0.5, 1.0)
	wasOnFloor = is_on_floor()
	
	var x_input = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	
	if x_input != 0:
		velocity.x += x_input * aceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		velocity.x = lerpf(velocity.x, 0, friction)
	
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	if is_on_floor():
		coyote_time = true
		CoyoteTimer.start(0.2)
	if is_on_floor() or coyote_time == true:
		if prejump == true: #Input.is_action_pressed("ui_space"):
			velocity.y = -jump_force
			coyote_time = false
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y /= 2
		
	move_and_slide()

func update_physics_no_movement(delta):
	var x_input = 0.0
	
	if x_input != 0:
		velocity.x += x_input * aceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		velocity.x = lerpf(velocity.x, 0, friction)
	
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	if is_on_floor():
		coyote_time = true
		CoyoteTimer.start(0.2)
	if is_on_floor() or coyote_time == true:
		if prejump == true: #Input.is_action_pressed("ui_space"):
			velocity.y = -jump_force
			coyote_time = false
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y /= 2
		
	move_and_slide()

func align():
	if velocity.x > 0.0:
		sprite.flip_h = false
		hitbox.scale.x = 1.0
	elif velocity.x < 0.0:
		sprite.flip_h = true
		hitbox.scale.x = -1.3

func jump(_delta):
	prejumpTimer.start(0.1)
	prejump = true

var currentKnockbackVector = Vector2.ZERO

func hit(attack : Attack):
	currentKnockbackVector = (global_position - attack.attack_position).normalized() * attack.knockback_force
	$HeroSprite/HitFlashComponent.flash()
	stateMachine.onChildTransition(stateMachine.current_state, "Stun")
	$IframeAnimator.play("Iframe")
	Game.slow_down(0.3, 0.1)
	$HitSprite.rotation_degrees = randf_range(0.0, 360.0)
	$HitSprite.play("Hit")
	camera.set_shake(5.0)
	$HitSound.playSound(0.75, 1.5)

func death(attack : Attack):
	currentKnockbackVector = (global_position - attack.attack_position).normalized() * attack.knockback_force
	$HeroSprite/HitFlashComponent.flash()
	stateMachine.onChildTransition(stateMachine.current_state, "Dead")
	Game.slow_down(1.0, 0.1)
	camera.set_shake(10.0)
	$HitSound.playSound()
	$IframeAnimator.play("Death")
	$HurtboxComponent.call_deferred("disable")

func setCutsceneMode(enter : bool):
	if enter:
		stateMachine.onChildTransition(stateMachine.current_state, "Cutscene")
	else:
		stateMachine.onChildTransition(stateMachine.current_state, "Idle")

func get_health():
	return(healthComponent.get_health())

func set_health(value : float):
	healthComponent.set_health(value)

func get_max_health():
	return(healthComponent.get_max_health())

func set_max_health(value : int = 10):
	healthComponent.set_max_health(value)

func _on_prejump_time_timeout():
	prejump = false

func _on_coyote_time_timeout():
	coyote_time = false

func _on_enable_smooth_camera_timer_timeout():
	camera.position_smoothing_enabled = true

func _on_iframe_animator_animation_finished(anim_name):
	if anim_name == "Death":
		pass
		#Game.playerDead()

func platformingStun():
	stateMachine.onChildTransition(stateMachine.current_state, "PlatformingRespawnStun")
