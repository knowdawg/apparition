extends "res://Levels/level.gd"

func _on_player_fall_intro_black_hole_animation_finished(anim_name):
	if anim_name == "PlayerFall":
		Game.respawnScene = "res://Levels/MainAreaLevels/central_save_room.tscn"
		Game.playerDead()
		#var data = SwitchSceneData.new()
		#data.scene = "res://Levels/MainAreaLevels/central_save_room.tscn"
		#data.door = "CentralDoor"
		#data.facingLeft = false
		#Game.switch_scene(data)
