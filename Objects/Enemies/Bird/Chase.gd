extends State
class_name BirdChase

@export var parent : Bird
@export var sprite : AnimatedSprite2D
@export var proximityComponent : ProximityAreaComponent

var switchStateDelay = 0.0

func update(delta):
	switchStateDelay -= delta
	
	parent.align(Game.player)
	if proximityComponent.is_player_inside() and switchStateDelay < 0.0:
		trasitioned.emit(self, "Run")

func update_physics(delta):
	parent.move(true, delta)

func enter():
	sprite.play("Idle")
	switchStateDelay = 0.5

func hit(_attack : Attack):
	trasitioned.emit(self, "Stun")
