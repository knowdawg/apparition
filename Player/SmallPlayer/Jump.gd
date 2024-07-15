extends State
class_name SmallPlayerJump

@export var animated_player_sprite : AnimationPlayer
@export var player : SmallPlayer

var t : float = 0.0
func update(delta):
	t += delta
	if t >= 0.2:
		animated_player_sprite.play("Jump")
		
	player.update_physics(delta, true, true)
	
	if player.velocity.y >= 0.0:
		trasitioned.emit(self, "Fall")

func enter():
	player.jump();
	t = 0
	animated_player_sprite.play("JumpStart")
