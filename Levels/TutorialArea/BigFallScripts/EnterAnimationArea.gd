extends Area2D

func _on_body_entered(body):
	if body == Game.player:
		$PlayerFallIntroBlackHole.play("PlayerFall")
