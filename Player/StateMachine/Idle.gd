extends State
class_name PlayerIdle

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player

func update(delta):
	player.update_physics(delta) 
	
	if Input.is_action_just_pressed("Jump"):
		player.jump(delta)
		trasitioned.emit(self, "Jump")
		return
	if Input.is_action_pressed("Attack"):
		trasitioned.emit(self, "Attack1")
		return
	if abs(player.velocity.x) > 5.0:
		trasitioned.emit(self, "Run")
		return
	if player.velocity.y > 0.0:
		trasitioned.emit(self, "Fall")
		return
	if Input.is_action_pressed("Bash") or player.getRightStickStrength():
		var bashTarget = player.bashProximity.get_bash_target()
		if bashTarget:
			player.bashSetup(bashTarget)
			trasitioned.emit(self, "Bash")

func enter():
	animated_player_sprite.play("Idle")
