extends State
class_name ReaperTeleport

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var attackProximity : ProximityAreaComponent
@export var sound : SoundPlayer

var t = 0.9
var hasTeleported = false

func update(delta):
	t -= delta
	if t > 0.4 and t < 0.5:
		if !hasTeleported:
			var leftOrRight = (randi_range(0,1) == 1)
			if leftOrRight == true:
				parent.position = Game.player.global_position - Vector2(20.0 - randf_range(0.0, 5.0), 2.0)
			else:
				parent.position = Game.player.global_position - Vector2(-20.0 + randf_range(0.0, 5.0), 2.0)
			hasTeleported = true
			
	if t <= 0.0:
		if attackProximity.is_player_inside() == true:
			trasitioned.emit(self, "attack")
		else:
			trasitioned.emit(self, "Run")

func enter():
	sound.playSound(0.9, 1.1)
	t = 0.9
	hasTeleported = false
	parent.velocity = Vector2.ZERO
	sprite.play("Teleport")
