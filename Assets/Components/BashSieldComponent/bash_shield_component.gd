extends Node2D
class_name BashShieldComponent

var shieldActive = false

@export var healthComponent : HealthComponent
@export var sprite : AnimatedSprite2D
@export var nonAnimatedSprite : Sprite2D
@export var shieldColor : Color = Color(1.0, 0.0, 0.0, 1.0)

func setShield(on : bool):
	shieldActive = on
	healthComponent.setHealthLock(shieldActive)
	
	var currSprite
	if sprite:
		currSprite = sprite
	else:
		currSprite = nonAnimatedSprite
	
	if on:
		currSprite.material.set_shader_parameter("color", shieldColor)
	else:
		currSprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0, 1.0))
		$AnimationPlayer.play("ShieldBreak")
		$EnemyHitEffectComponent.play("Hit")
		Game.slow_down(0.5, 0.05)

func getShield():
	return shieldActive
