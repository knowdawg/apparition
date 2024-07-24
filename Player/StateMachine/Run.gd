extends State
class_name PlayerRun

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player
@export var sound : AudioStreamPlayer

var soundTimer = 0.0
func update(delta):
	soundTimer -= delta
	if soundTimer <= 0.0:
		soundTimer = 0.3
		sound.pitch_scale = randf_range(0.5, 1.0)
		sound.play()
	
	player.update_physics(delta)
	
	player.align()
		
	if Input.is_action_just_pressed("Jump"):
		player.jump(delta)
		trasitioned.emit(self, "Jump")
	if Input.is_action_pressed("Attack"):
		trasitioned.emit(self, "Attack1")
		return
	if abs(player.velocity.x) < 5.0:
		trasitioned.emit(self, "Idle")
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
	animated_player_sprite.play("Run")
	soundTimer = 0.0

func exit(_newState):
	sound.stop()
