extends State
class_name ReaperRun

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var teleportProximity : ProximityAreaComponent
@export var attackProximity : ProximityAreaComponent

func update(_delta):
	if teleportProximity.is_player_inside() == false:
		trasitioned.emit(self, "Teleport")
	
	if attackProximity.is_player_inside() == true:
		trasitioned.emit(self, "Attack")

func update_physics(delta):
	parent.move(true, delta)

func enter():
	sprite.play("Move")
