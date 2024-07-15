extends AnimatedSprite2D

@export var scaleMultiplier : float = 1.0

func hit():
	rotation_degrees = randf_range(0.0, 360.0)
	var randScale = randf_range(0.8, 1.2) * scaleMultiplier
	scale = Vector2(randScale, randScale)
	play("Hit")
