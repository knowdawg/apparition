extends Node2D

var t = 0.0
func _process(delta):
	t -= delta
	if t <= 0.0:
		$HitboxComponent.generateAttackID()
		t = 0.5


func _on_hitbox_component_area_entered(_area):
	Game.platformingRespawn()
