extends "res://Levels/level.gd"

@onready var topDoorShapeEnableAfterDrop = $Foreground/Doors/TopDoor2/CollisionShape2D

func _on_area_2d_body_entered(body):
	if body is Player:
		topDoorShapeEnableAfterDrop.set_deferred("disabled", false)

func _on_final_cutscene_body_entered(body):
	if body is Player:
		Game.switchToFinalCutscene()
