extends State
class_name PlayerFall

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player

func update(delta):
	player.update_physics(delta)
	
	player.align()
	
	if Input.is_action_pressed("Attack"):
		trasitioned.emit(self, "Attack1")
		return
	if player.velocity.y == 0.0:
		trasitioned.emit(self, "Idle")
		return
	if Input.is_action_just_pressed("Jump"):
		if player.coyote_time == true:
			player.jump(delta)
			trasitioned.emit(self, "Jump")
	if Input.is_action_pressed("Bash") or player.getRightStickStrength():
		var bashTarget = player.bashProximity.get_bash_target()
		if bashTarget:
			player.bashSetup(bashTarget)
			trasitioned.emit(self, "Bash")

func enter():
	animated_player_sprite.play("Fall")
