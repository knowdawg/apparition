extends Node2D
class_name Level

var doors = []
var playerPackage = preload("res://Player/player.tscn")
var player

@export var playerStartingPosOnFalure : Vector2 = Vector2.ZERO
@export var rp : respawnPoint

@onready var foregound = $Foreground
 
func add_projectile(p):
	foregound.add_child(p)

func _ready():
	
	MainAreaMusic.play()
	
	Game.currentLevel = self
	
	if Game.isPlayerDead == true:
		if rp:
			rp.respawn.connect(respawnPlayer)
			rp.playRespawnAnimation()
		else:
			printerr("ERROR: No Respawn Point")
			player = playerPackage.instantiate()
			player.position = playerStartingPosOnFalure;
			
			$Foreground.add_child(player)
			player.initialize(Game.maxPlayerHealth, false, true, Game.maxPlayerHealth, Game.playerDmg)
			Game.isPlayerDead = false
	else:
		player = playerPackage.instantiate()
		player.position = get_player_starting_pos()
		$Foreground.add_child(player)
		
		if Game.playerHealth:
			player.initialize(Game.playerHealth, Game.playerFacingLeft, false, Game.maxPlayerHealth, Game.playerDmg)
		else: #Should Only Trigger Upon Starting The Game
			player.initialize(Game.maxPlayerHealth, false, false, Game.maxPlayerHealth, Game.playerDmg) #default player instance

func respawnPlayer():
	player = playerPackage.instantiate()
	player.position = rp.getRespawnLoc();
	$Foreground.add_child(player)
	player.initialize(Game.maxPlayerHealth, false, true, Game.maxPlayerHealth, Game.playerDmg)
	Game.isPlayerDead = false

func get_player_starting_pos():
	doors.clear()
	for c in find_child("Doors").get_children():
		if c is Door:
			doors.append(c)
	
	for d in doors:
		if d.name == Game.doorEnterName:
			return d.get_spawn_pos()
	return playerStartingPosOnFalure
