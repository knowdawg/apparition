extends Node2D

func _ready():
	$Sprite.play("Blast")
	$AnimationPlayer.play("Blast")

func _on_timer_timeout():
	queue_free()
