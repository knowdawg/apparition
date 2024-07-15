extends State
class_name ReaperDeath

@export var parent : Reaper
@export var sprite : AnimatedSprite2D

func update_physics(delta):
	parent.velocity.y += 500 * delta

func enter():
	parent.velocity = Vector2.ZERO
	sprite.play("Death")
