extends Area2D
class_name HitboxComponent

@export var collisionShape : CollisionShape2D

@export var attack_damage : float
@export var knockback_force: float
@export var isBashAttack : bool = false
@export var isSpikes : bool = false

@onready var attackID : float = randf()

func _on_area_entered(area):
	if area is HurtboxComponent:
		var hurtbox : HurtboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.is_bash_attack = isBashAttack
		attack.attackID = attackID
		attack.is_spikes = isSpikes
		
		hurtbox.damage(attack)
		
		if Game.currentCamera:
			if Game.currentCamera.shake_strength <= 0.3:
				Game.currentCamera.set_shake(0.3)
		
func generateAttackID():
	attackID = randf()

func disable():
	$CollisionShape2D.disabled = true

func enable():
	$CollisionShape2D.disabled = false
	generateAttackID()
