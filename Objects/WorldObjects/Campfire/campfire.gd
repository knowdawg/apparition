extends Node2D
class_name CampFire

func _ready():
	$AnimatedSprite2D.play("Burn")

func _process(delta):
	if $ProximityArea.is_player_inside():
		Game.coldLevel = clamp(Game.coldLevel, 0.0, 0.9)
		if Game.coldLevel > 0.0:
			Game.coldLevel -= delta * 0.2
