extends StaticBody2D

@export var c : CollisionShape2D

func _physics_process(_delta):
	if c:
		if Input.is_action_pressed("Down"):
			c.disabled = true
			$DownDisableTimer.start()
			return
		
		if $DownDisableTimer.time_left == 0:
			if is_instance_valid(Game.player):
				if Game.player.global_position.y + 5 > global_position.y:
					c.disabled = true
				else:
					c.disabled = false
