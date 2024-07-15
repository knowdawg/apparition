extends State
class_name PlayerBash

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player

func enter():
	animated_player_sprite.play("Hurt")

func update(delta):
	Game.player.position = lerp(Game.player.position, Game.player.bashTargetPosition, 6.0 * delta)
	#if Input.is_action_just_pressed("Attack"):
		#player.bashEarly()
	#if Input.is_action_just_pressed("Bash"):
		#player.consumeBash()

func update_physics(_delta):
	Game.player.move_and_slide()
