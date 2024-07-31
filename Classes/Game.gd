extends Node

var controler = false

var currentLevel
var currentCamera : Camera2DPlus
var player : Player
var platformingRespawnPos : Vector2

var isPlayerDead = false;

var playerSpawnForFirstTime = false
var bossDialogFirstTime = true

var slomoTimer = 0.0
var normalTimeScale = 1.0
func slow_down(durration: float, time_scale : float):
	slomoTimer = (durration * time_scale)
	Engine.time_scale = time_scale

var cameraLimitSmoothing = 0.0

var coldLevel = 0.0

#SAVE FILE STUFF
var enemyManagerCompletionStatus : Dictionary = {}
var checkpointGateActivationStatus : Dictionary = {}
var healthUpgradeStatus : Dictionary = {}
var weaponUpgradeStatus : Dictionary = {}
var respawnScene : String
var maxPlayerHealth : float
var playerDmg : float

var playerFile = "user://save.dat"

var masterVolume : float = 1.0
var soundEfectsVolume : float = 1.0
var musicVolume : float = 1.0
var settingFile = "user://settings.dat"

func save():
	var file = FileAccess.open(playerFile, FileAccess.WRITE)
	file.store_var(createPlayerData())
	
	var sFile = FileAccess.open(settingFile, FileAccess.WRITE)
	sFile.store_var(createSettingsData())

func createNewSave():
	enemyManagerCompletionStatus = {}
	checkpointGateActivationStatus = {}
	healthUpgradeStatus = {}
	weaponUpgradeStatus = {}
	respawnScene = ""
	maxPlayerHealth = 10.0
	playerDmg = 1.0
	
	save()

func loadSave():
	if FileAccess.file_exists(playerFile):
		var file = FileAccess.open(playerFile, FileAccess.READ)
		var loadedData = file.get_var()
		enemyManagerCompletionStatus = loadedData.enemyManagerData
		checkpointGateActivationStatus = loadedData.checkpointGateData
		healthUpgradeStatus = loadedData.healthUpgradeData
		weaponUpgradeStatus = loadedData.weaponUpgradeData
		respawnScene = loadedData.checkpoint
		maxPlayerHealth = loadedData.maxHealth
		playerDmg = loadedData.playerDmg

func loadSettingSave():
	if FileAccess.file_exists(settingFile):
		var file = FileAccess.open(settingFile, FileAccess.READ)
		var loadedData = file.get_var()
		masterVolume = loadedData.masterVolume
		soundEfectsVolume = loadedData.soundEfectsVolume
		musicVolume = loadedData.musicVolume

func createPlayerData():
	var playerData : Dictionary = {
		"enemyManagerData" : enemyManagerCompletionStatus,
		"checkpointGateData" : checkpointGateActivationStatus,
		"healthUpgradeData" : healthUpgradeStatus,
		"weaponUpgradeData" : weaponUpgradeStatus,
		"checkpoint" : respawnScene,
		"maxHealth" : maxPlayerHealth,
		"playerDmg" : playerDmg
	}
	return playerData

func createSettingsData():
	var sData : Dictionary = {
		"masterVolume" : masterVolume,
		"soundEfectsVolume" : soundEfectsVolume,
		"musicVolume" : musicVolume
	}
	return sData

func _exit_tree():
	save()

func _ready():
	#createNewSave()
	loadSave()
	loadSettingSave()

func pause():
	get_tree().paused = true
		
func resume():
	get_tree().paused = false

func get_volume(isEffect : bool):
	var db = 1.0
	if isEffect == true:
		db = log(masterVolume * soundEfectsVolume)
	else:
		db = log(masterVolume * musicVolume)
	return((db * 20.0))

func _process(delta):
	if Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)).length() > 0.1:
		controler = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		controler = false
	
	
	slomoTimer -= delta
	if slomoTimer <= 0.0:
		Engine.time_scale = 1.0
	
	cameraLimitSmoothing -= delta
	if cameraLimitSmoothing < 0.0:
		return
	currentCamera.position_smoothing_speed = 10.0 * pow((1.0 - cameraLimitSmoothing * 4.0), 1.0)
	

var doorEnterName
var playerHealth
var playerFacingLeft : bool
var screenTransition = preload("res://Assets/ScreenTransitions/screen_transition.tscn")
var p
var s

func switch_scene(data : SwitchSceneData):
	if s != null:
		s.queue_free()
	if isPlayerDead:
		p = data.scene
		s = screenTransition.instantiate()
		add_child(s)
		s.fadeIn()
		s.fadeInComplete.connect(fadeComplete)
	else:
		if is_instance_valid(player):
			playerHealth = player.get_health()
		doorEnterName = data.door
		playerFacingLeft = data.facingLeft
		p = data.scene
		s = screenTransition.instantiate()
		add_child(s)
		s.fadeIn()
		s.fadeInComplete.connect(fadeComplete)

func switchSceneNoData(scenePath):
	get_tree().call_deferred("change_scene_to_file", scenePath)

func fadeComplete():
	get_tree().call_deferred("change_scene_to_file", p)
	s.fadeOut()

var playerPlatformRespawning = false
func platformingRespawn():
	if isPlayerDead == false and playerPlatformRespawning == false:
		playerPlatformRespawning = true
		if platformingRespawnPos:
			if s != null:
				s.queue_free()
			s = screenTransition.instantiate()
			add_child(s)
			s.fadeIn()
			s.fadeInComplete.connect(platformRespawnFadeComplete)
		else:
			player.position = Vector2.ZERO
			printerr("No respawn point for platforming respawn!")

func platformRespawnFadeComplete():
	playerPlatformRespawning = false
	player.position = platformingRespawnPos
	player.platformingStun()
	s.fadeOut()

func switchToFinalCutscene():
	switchSceneNoData("res://Levels/FinalCutscene/final_cutscene.tscn")


func cameraBoundsChanged():
	cameraLimitSmoothing = 0.25

func playerDead():
	isPlayerDead = true;
	var data = SwitchSceneData.new()
	data.scene = respawnScene
	switch_scene(data)
	MainAreaMusic.combat = false
