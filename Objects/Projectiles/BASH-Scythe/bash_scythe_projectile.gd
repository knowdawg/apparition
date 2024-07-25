extends Node2D

@export var SPEED = 300
var dirrection = Vector2.ZERO

var t = 1.0

func _process(delta):
	t -= delta * 0.5
	
	var tEXP = pow(t, 10.0)
	
	position += SPEED * dirrection * delta * tEXP
	
	if t <= 0.0:
		queue_free()

func initialize(dir : Vector2):
	$AnimationPlayer.play("Spin")
	dirrection = dir
	$AnimatedSprite2D.play("Spin")
	$BashSound.playSound()
