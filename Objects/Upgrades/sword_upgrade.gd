extends Node2D

@export var isHilt = true
@export var room : Level
var colected = false

@onready var id : String = room.get_name() + get_name()
func _ready():
	if isHilt:
		$Hilt.visible = true
		$Blade.visible = false
	else:
		$Hilt.visible = false
		$Blade.visible = true
		
	if Game.weaponUpgradeStatus.has(id):
		$AnimationPlayer.play("Idle")
		if Game.weaponUpgradeStatus[id] == true:
			colected = true
			$AnimationPlayer.play("RESET")
			$Hilt.visible = false
			$Blade.visible = false
	else:
		Game.weaponUpgradeStatus[id] = false
		$AnimationPlayer.play("Idle")

func _on_area_2d_body_entered(body):
	if body is Player and colected == false:
		Game.weaponUpgradeStatus[id] = true
		colected = true
		$AnimationPlayer.play("Colect")
		if isHilt:
			$CanvasLayer/Outline/Blade.visible = hasOtherUpgrade()
			$CanvasLayer/Outline/Blade2.visible = hasOtherUpgrade()
			$CanvasLayer/Outline/Hilt.visible = false
		else:
			$CanvasLayer/Outline/Blade.visible = false
			$CanvasLayer/Outline/Blade2.visible = false
			$CanvasLayer/Outline/Hilt.visible = hasOtherUpgrade()

func hasOtherUpgrade():
	for i in Game.weaponUpgradeStatus.values():
		if i == false:
			return false
	if Game.weaponUpgradeStatus.size() == 2:
		Game.playerDmg = 1.5
		return true
	else:
		return false

func showUI():
	if isHilt:
		$CanvasLayer/Outline/Hilt.visible = true
	else:
		$CanvasLayer/Outline/Blade.visible = true
		$CanvasLayer/Outline/Blade2.visible = true
