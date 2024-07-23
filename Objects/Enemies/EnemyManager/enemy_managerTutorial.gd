extends "res://Objects/Enemies/EnemyManager/enemy_manager.gd"


func onNextWave():
	if currentWave == 0:
		$AttackText.enable()
	if currentWave == 1:
		$AttackText.disable()
		$BashText.enable()

func onEncounterEnd():
	$BashText.disable()
	$BashText2.enable()
