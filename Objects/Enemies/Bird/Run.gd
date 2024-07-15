extends State
class_name BirdRun

@export var parent : Bird
@export var sprite : AnimatedSprite2D
@export var proximityComponent : ProximityAreaComponent

var switchStateDelay = 0.0

var timesSwitched = 0
var doAttack = false

func update(delta):
	switchStateDelay -= delta
	
	parent.align(Game.player)
	if !proximityComponent.is_player_inside() and switchStateDelay < 0.0:
		trasitioned.emit(self, "Chase")
	
	if doAttack == true:
		trasitioned.emit(self, "Attack")
		doAttack = false
		return

func update_physics(delta):
	parent.move(false, delta)
	parent.velocity.y -= 20.0 * delta

func enter():
	sprite.play("Idle")
	switchStateDelay = 0.5
	
	timesSwitched += 1
	if timesSwitched >= 2:
		doAttack = true
		timesSwitched = 0

func hit(_attack : Attack):
	trasitioned.emit(self, "Stun")
