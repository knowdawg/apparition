extends State
class_name ZombieHitStun

@export var parrent : Zombie
@export var sprite : AnimatedSprite2D

@export var stunTime : float = 0.5
var currentStunTime

func update_physics(delta):
	parrent.update_physics(delta)

func update(delta):
	currentStunTime -= delta
	if currentStunTime <= 0.0:
		trasitioned.emit(self, "Idle")

func enter():
	currentStunTime = stunTime
	sprite.play("Stun")

func hit(_attack : Attack):
	currentStunTime = stunTime
