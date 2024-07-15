extends TextureProgressBar


func update(health : float, maxHealth : float):
	value = (health / maxHealth) * 100.0

func hit(_dmg : float, _prevhealth : float):
	pass
