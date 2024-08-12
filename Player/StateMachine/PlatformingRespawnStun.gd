extends State
class_name playerPlatformingRespawnStun

@export var sprite : AnimatedSprite2D
@export var player : Player
@export var hurtBox : HurtboxComponent
@export var iFramAnim : AnimationPlayer
@export var healthComponent : HealthComponent

var timer : float = 1.0

func update(delta):
	if healthComponent.get_health() <= 0.0:
		trasitioned.emit(self, "Dead")
	iFramAnim.play("Iframe")
	timer -= delta
	if timer <= 0:
		if healthComponent.get_health() > 0.0:
			trasitioned.emit(self, "Idle")

func update_physics(delta):
	player.update_physics_no_movement(delta)

func enter():
	player.currentKnockbackVector = Vector2.ZERO
	sprite.play("PlatformingGetup")
	timer = 1.0
	hurtBox.setIFrameTimer(1.5)
