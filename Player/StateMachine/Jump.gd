extends State
class_name PlayerJump

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player

func update(delta):
	player.update_physics(delta)
	
	player.align()
	
	if Input.is_action_pressed("Attack"):
		trasitioned.emit(self, "Attack1")
		return
	if player.velocity.y > 0.0:
		trasitioned.emit(self, "Fall")
	if Input.is_action_pressed("Bash") or player.getRightStickStrength():
		var bashTarget = player.bashProximity.get_bash_target()
		if bashTarget:
			player.bashSetup(bashTarget)
			trasitioned.emit(self, "Bash")

func enter():
	animated_player_sprite.play("Jump")
