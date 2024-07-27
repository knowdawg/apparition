extends State
class_name playerGetup

@export var sprite : AnimatedSprite2D
@export var player : Player

var timer : float = 3.8

func update(delta):
	timer -= delta
	if timer <= 0:
		trasitioned.emit(self, "Idle")

func update_physics(delta: float):
	player.update_physics_no_movement(delta)

func enter():
	sprite.play("Getup")
	timer = 3.8
