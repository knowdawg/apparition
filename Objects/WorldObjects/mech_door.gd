extends AnimatedSprite2D

var isOpen = false
var t = 0.0

func open():
	if is_instance_valid(Game.player):
		Game.player.setCutsceneMode(false)
	$SoundPlayerNot2D.playSound()
	if !isOpen:
		play("default")
		isOpen = true


func _process(delta):
	if isOpen:
		t += delta
		if t > 1.2:
			$StaticBody2D/CollisionShape2D.disabled = true
		if t > 1.6:
			$StaticBody2D2/CollisionShape2D.disabled = true
		if t > 2.0:
			$StaticBody2D3/CollisionShape2D.disabled = true
	
	if $ProximityArea.is_player_inside():
		if !isOpen:
			$Animator.play("Open")
			if is_instance_valid(Game.player):
				Game.player.setCutsceneMode(true)
