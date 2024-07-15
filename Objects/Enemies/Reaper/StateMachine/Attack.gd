extends State
class_name ReaperAttack

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var hitbox : HitboxComponent

var t = 2.3

func update(delta):
	t -= delta
	
	if t > 0.9 and t < 1.2:
		hitbox.collisionShape.disabled = false
	else:
		hitbox.collisionShape.disabled = true
	
	if t<= delta:
		trasitioned.emit(self, "Run")

func enter():
	hitbox.generateAttackID()
	
	parent.velocity = Vector2.ZERO
	t = 2.3
	sprite.play("Attack")
	
	if Game.player.global_position >= parent.global_position:
		hitbox.scale.x = -1.0
		sprite.flip_h = true
	else:
		hitbox.scale.x = 1.0
		sprite.flip_h = false
