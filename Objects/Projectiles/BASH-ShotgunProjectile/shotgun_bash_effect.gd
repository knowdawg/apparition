extends Node2D

func _ready():
	$Sprite.play("Blast")
	$AnimationPlayer.play("Blast")
	$SpawnSound.playSound()

func _on_timer_timeout():
	$HitboxComponent/CollisionShape2D.disabled = true
	$Sprite.visible = false


func _on_spawn_sound_finished():
	queue_free()
