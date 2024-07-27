extends Area2D
class_name EnemyManager

var zombie = preload("res://Objects/Enemies/Zombie/zombie.tscn")
var bird = preload("res://Objects/Enemies/Bird/bird.tscn")
var reaper = preload("res://Objects/Enemies/Reaper/reaper.tscn")

var enemies = []
var numOfEnemies : int = 0
var gates = []
var enemySpawns = []

var enemySpawnQue = []

var encounterStated = false
var encounterCompleted = false

@export var totalWaves : int = 1
var currentWave : int = 0

@export var fodderSpawn : EnemySpawnPoint

func onEncounterStart():
	pass

func encounterStart():
	for gate in gates:
		gate.close()
	for enemy in enemies:
		enemy.encounterStart();
	if currentWave == 0:
		call_deferred("nextWave")
	MainAreaMusic.combat = true
	onEncounterStart()

func onEncounterEnd():
	pass

func encounterEnd():
	onEncounterEnd()
	encounterStated = true
	encounterCompleted = true
	var id : String = Game.currentLevel.get_name() + get_name()
	Game.enemyManagerCompletionStatus[id] = true
	for gate in gates:
		gate.open()
	MainAreaMusic.combat = false

func _ready():
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
			child.dead.connect(enemyDead)
			numOfEnemies += 1
		if child is Gate:
			gates.append(child)
		if child is EnemySpawnPoint:
			enemySpawns.append(child)

func enemyDead(enemy : Enemy):
	numOfEnemies -= 1
	enemies.remove_at(enemies.find(enemy))
	if numOfEnemies <= 0:
		currentWave += 1
		if currentWave > totalWaves:
			encounterEnd()
		else:
			call_deferred("nextWave")
	
	$FodderTimer.start()

func _on_body_entered(body):
	#Checks if this encounter is in Game. If it is, check if has been completed and set status acordingly
	#Else, add to the dictionary and set status acordingly
	var id : String = Game.currentLevel.get_name() + get_name()
	if Game.enemyManagerCompletionStatus.has(id):
		if Game.enemyManagerCompletionStatus[id] == true:
			encounterCompleted = true
	else:
		Game.enemyManagerCompletionStatus[id] = false
		encounterCompleted = false
	
	if body is Player and encounterStated == false and encounterCompleted == false:
		encounterStart()
		encounterStated = true

func onNextWave():
	pass

func nextWave():
	onNextWave()
	for sp in enemySpawns:
		if sp.wave == currentWave:
			enemySpawnQue.append(sp)


func addEnemy(newEnemy, enemyPosition):
	add_child(newEnemy)
	enemies.append(newEnemy)
	numOfEnemies += 1
	newEnemy.dead.connect(enemyDead)
	newEnemy.position = enemyPosition


func _on_timer_timeout():
	#print(enemies)
	if enemySpawnQue.size() > 0:
		enemySpawnQue[0].spawn()
		enemySpawnQue.remove_at(0)

func _on_fodder_timer_timeout():
	if enemies.size() == 0:
		return
	for e in enemies: #if all enemies have a bash sheild, spawn a fodder enemy
		if e.bashShield == false:
			return
	spawnFodder()

func spawnFodder():
	if fodderSpawn:
		enemySpawnQue.append(fodderSpawn)
