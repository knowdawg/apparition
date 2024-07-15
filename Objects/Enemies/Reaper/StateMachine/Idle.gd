extends State
class_name ReaperIdle

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var proximityComponent : ProximityAreaComponent

func update(_delta):
	if proximityComponent.is_player_inside():
		trasitioned.emit(self, "Run")

func enter():
	sprite.play("Idle")
