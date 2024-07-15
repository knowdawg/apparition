extends State
class_name SmallPlayerFall

@export var animated_player_sprite : AnimationPlayer
@export var animated_scale : AnimationPlayer
@export var player : SmallPlayer

var t : float = 0.0
func update(delta):
	player.update_physics(delta, true, true)
	
	if player.velocity.y == 0.0:
		trasitioned.emit(self, "Idle")
		animated_scale.play("HitGround")
		return
	#if Input.is_action_just_pressed("Jump"):
		#if player.coyote_time == true:
			#player.jump(delta)
			#trasitioned.emit(self, "Jump")

func enter():
	t = 0.0
	animated_player_sprite.play("Fall")
