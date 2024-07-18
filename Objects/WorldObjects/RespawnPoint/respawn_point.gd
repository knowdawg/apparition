extends Node2D
class_name respawnPoint

@export var respawnScene : String

var active = false

signal respawn

func getRespawnLoc():
	return $RespawnLoc.global_position

func _on_area_2d_body_entered(body):
	if body is Player:
		Game.respawnScene = respawnScene;
		Game.player.set_health(Game.maxPlayerHealth)
		if active == false:
			active = true
			$AnimationPlayer.play("Activate")

func playRespawnAnimation():
	$AnimationPlayer.play("Respawn")

func respawnPlayer():
	respawn.emit();
	Game.currentCamera.set_shake(10.0)

func _process(delta):
	if $AnimationPlayer.current_animation == "Respawn":
		$Camera2D.add_shake(0.3 * delta)

func _ready():
	if Game.respawnScene == respawnScene:
		active = true
		$Cubes.material.set_shader_parameter("progress", 1.0)
	else:
		active = false
		$Cubes.material.set_shader_parameter("progress", 0.0)
		$AnimationPlayer.play("Idle")
