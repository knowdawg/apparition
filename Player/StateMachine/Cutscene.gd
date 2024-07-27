extends State
class_name playerCutscene

@export var sprite : AnimatedSprite2D
@export var player : Player

var timer : float = 1.0


func update_physics(delta):
	player.update_physics_no_movement(delta)

func enter():
	sprite.play("Idle")
