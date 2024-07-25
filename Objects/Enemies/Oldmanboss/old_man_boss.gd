extends Enemy
class_name OldManBoss

@export var stateMachine : Node
@export var sprite : Sprite2D

var phase = 1

var projectile = preload("res://Objects/Enemies/Oldmanboss/Projectiles/boss_arrow.tscn")
var projectiles = []

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func fireProjectile(direction : Vector2, speed : float):
	var p = projectile.instantiate()
	p.initialize(direction, speed)
	Game.currentLevel.add_projectile(p)
	p.position = $ProjectileStartLocation.global_position
	p.boss = self
	projectiles.append(p)
	
func removeProjectile(arrow : BossArrow):
	var index = projectiles.find(arrow)
	projectiles.remove_at(index)

func encounterStart():
	stateMachine.current_state.stand()

func align():
	if Game.player.global_position > global_position:
		sprite.flip_h = true
	elif Game.player.global_position < global_position:
		sprite.flip_h = false


var arrowFlashObject = preload("res://Objects/Enemies/Oldmanboss/arrow_flash.tscn")
func arrowFlash(pos : Vector2, rotDeg : float, isQuad : bool, whatPhase : int = 1, animSpeed : float = 1.0):
	if whatPhase <= phase:
		var a = arrowFlashObject.instantiate()
		add_child(a)
		a.initiate(pos, rotDeg, isQuad, animSpeed)
		
		if $Sprite.flip_h == true:
			a.scale.x = -1
			a.position.x *= -1
		else:
			a.scale.x = 1

func hit(attack : Attack):
	do_hit_effect(attack)
	
	if $Components/HealthComponent.health < $Components/HealthComponent.MAX_HEALTH * 0.6 and phase == 1:
		phase = 2
		velocity *= 2
		stateMachine.current_state.trasitioned.emit(stateMachine.current_state, "PhaseTransition")
		$Phase2Particles.emitting = true
	#if attack.is_bash_attack and bashShieldComponent.getShield():
		#bashShieldComponent.setShield(false)
		
func do_hit_effect(attack):
	
	if attack.attack_damage > 0.0:
		$Components/HitAnimator.play("Hit")
		$Hit.playSound(0.8, 1.2)
	
	velocity = (global_position - attack.attack_position).normalized() * attack.knockback_force
	
	#if attack.attack_position > global_position:
		#$Components/HitParticles.rotation_degrees = 180.0
	#elif attack.attack_position < global_position:
		#$Components/HitParticles.rotation_degrees = 0.0

func death(attack):
	hit(attack)
	dead.emit(self)
	$Components/HurtboxComponent.call_deferred("disable")
	$StateMachine.current_state.trasitioned.emit($StateMachine.current_state, "Dead")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
