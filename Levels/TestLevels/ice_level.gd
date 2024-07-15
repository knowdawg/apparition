extends Level

@export var coldEffect : ColdEffect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.coldLevel < 0.2:
		Game.coldLevel += delta * 0.1
	elif Game.coldLevel < 0.3:
		Game.coldLevel += delta * 0.05
	elif Game.coldLevel < 0.4:
		Game.coldLevel += delta * 0.01
	elif Game.coldLevel< 1.0:
		Game.coldLevel += delta * 0.05
	
	if coldEffect:
		coldEffect.set_cold(Game.coldLevel)
	
	if Game.coldLevel >= 0.9:
		var freezeAttack : Attack = Attack.new()
		freezeAttack.attack_damage = 1
		freezeAttack.knockback_force = 0
		freezeAttack.attack_position = Game.player.global_position
		freezeAttack.attackID = randi()
		
		Game.player.hurtbox.damage(freezeAttack)
