extends State
class_name BirdChase

@export var parent : Bird
@export var sprite : AnimatedSprite2D
@export var proximityComponent : ProximityAreaComponent

var switchStateDelay = 0.0

var t = 5.0

func update(delta):
	t -= delta;
	switchStateDelay -= delta
	
	parent.align(Game.player)
	if proximityComponent.is_player_inside() and switchStateDelay < 0.0:
		trasitioned.emit(self, "Run")
	
	if t <= 0.0:
		trasitioned.emit(self, "Attack")

func update_physics(delta):
	parent.move(true, delta)

func enter():
	sprite.play("Idle")
	switchStateDelay = 0.5
	t = 5.0

func hit(_attack : Attack):
	trasitioned.emit(self, "Stun")
