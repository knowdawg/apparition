extends State
class_name BidDeath

@export var parent : Bird
@export var sprite : AnimatedSprite2D

func enter():
	sprite.play("Death")
