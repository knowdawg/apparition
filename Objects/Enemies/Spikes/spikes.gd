extends Node2D

func _on_hitbox_component_body_entered(body):
	$HitboxComponent.generateAttackID()
	if body == Game.player:
		if Game.player.get_health() > $HitboxComponent.attack_damage:
			Game.platformingRespawn()


func _on_hitbox_component_area_entered(_area):
	$HitboxComponent.generateAttackID()
