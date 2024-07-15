extends State
class_name ZombieIdle

@export var parrent : Zombie
@export var proximityArea : ProximityAreaComponent
@export var sprite : AnimatedSprite2D

func update(_delta):
	if proximityArea.is_player_inside():
		trasitioned.emit(self, "Chase")

func update_physics(delta):
	parrent.update_physics(delta)

func enter():
	sprite.play("Idle")

func hit(_attack : Attack):
	trasitioned.emit(self, "HitStun")
