extends StaticBody2D
class_name twoWayPlatform

@export var c : CollisionShape2D

func _physics_process(_delta):
	if c:
		if Input.is_action_pressed("Down"):
			set_collision_layer_value(1, false)
			$DownDisableTimer.start()
			return
		
		if $DownDisableTimer.time_left == 0:
			if is_instance_valid(Game.player):
				if Game.player.global_position.y + 5 > global_position.y:
					set_collision_layer_value(1, false)
				else:
					set_collision_layer_value(1, true)
