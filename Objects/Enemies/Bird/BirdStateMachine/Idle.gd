extends State
class_name BirdIdle

@export var parent : Bird
@export var sprite : AnimatedSprite2D
@export var proximityComponent : ProximityAreaComponent


func update(_delta):
	if proximityComponent.is_player_inside():
		trasitioned.emit(self, "Chase")

func enter():
	sprite.play("Idle")

func hit(_attack : Attack):
	trasitioned.emit(self, "Stun")
