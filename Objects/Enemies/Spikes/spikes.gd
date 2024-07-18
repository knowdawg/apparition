extends Node2D

func _on_hitbox_component_body_entered(_body):
	Game.platformingRespawn()


var t = 0.0
func _process(delta):
	t -= delta
	if t <= 0.0:
		$HitboxComponent.generateAttackID()
		t = 0.5
