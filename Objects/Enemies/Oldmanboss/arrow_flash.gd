extends Node2D

var triSprite = preload("res://Objects/Enemies/Oldmanboss/BossFlash2.png")

func initiate(pos : Vector2, rotDeg : float, isQuad : bool, animSpeed : float):
	$AnimationPlayer.speed_scale = animSpeed
	rotation_degrees = rotDeg
	position = pos
	if isQuad == false:
		$Sprite.texture = triSprite
		$AnimationPlayer.play("TriFlash")
	else:
		$AnimationPlayer.play("Flash")

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
