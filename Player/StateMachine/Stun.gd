extends State
class_name playerStun

@export var sprite : AnimatedSprite2D
@export var player : Player

var timer : float = 0.2

func update(delta):
	timer -= delta
	if timer <= 0:
		trasitioned.emit(self, "Idle")

var k
func update_physics(delta):
	#calculate knockback
	if !k:
		k = player.currentKnockbackVector
	k = lerp(k, Vector2(0.0,0.0), 0.2 * delta * 60)
	player.velocity = k
	player.move_and_slide()

func enter():
	sprite.play("Hurt")
	timer = 0.2
	
func exit(_newState):
	player.velocity = Vector2.ZERO
	k = null
