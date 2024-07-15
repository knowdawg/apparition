extends State
class_name BirdAttack

@export var parent : Bird
@export var sprite : AnimatedSprite2D

var timer = 0.0
var has_attacked = false

func update_physics(delta):
	if timer > 0.5:
		parent.velocity = Vector2.ZERO
	elif timer < 0.5 and timer > 0.4:
		parent.move(false, delta)
		parent.velocity = parent.velocity.normalized() * 2500.0 * delta
		if has_attacked == false:
			parent.arrow_attack(-(parent.global_position - Game.player.global_position).normalized())
			has_attacked = true

func update(delta):
	timer -= delta
	if timer <= 0.0:
		trasitioned.emit(self, "Chase")

func enter():
	sprite.play("Attack")
	#parent.velocity = Vector2.ZERO
	timer = 0.9
	has_attacked = false
