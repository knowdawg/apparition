extends State
class_name BossIdle

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer
@export var longRangeProximity : ProximityAreaComponent
@export var closeRangeProximity : ProximityAreaComponent

var stamina : int = 200

var staminaCosts = {"PalmStrike" : 50, "Uppercut" : 50,
 "Fireball" : 50, "Dash" : 20, "Snap" : 20, "GroundSlam" : 50, "Projectiles" : 30,
"Teleport" : 10, "BossPalmStrikeFakeOut" : 100}

var prevMove = ""

var timer : float = 0.4
var recharge = false

var crazyComboCooldown = 15

func update(delta):
	#If recharging, next move will not be selected until stamina has recharged
	timer -= delta
	if recharge == true:
		if stamina >= 200:
			recharge = false
			stamina = 200
		if timer < 0:
			timer += 0.4
			stamina += 80
		parent.align()
		return
		
	parent.align()
	var isPlayerClose = closeRangeProximity.is_player_inside()
	var isPlayerMedium = longRangeProximity.is_player_inside() and !isPlayerClose
	var isPlayerFar = !longRangeProximity.is_player_inside()
	
	if crazyComboCooldown <= 0 and parent.phase == 2:
		crazyComboCooldown = 15
		trasitioned.emit(self, "CrazyCombo")
	
	if parent.projectiles.size() > 0:
		if randi_range(0, 4) == 0:
			trasitioned.emit(self, "Snap")
	
	#if parent.projectiles.size() > 8:
		#trasitioned.emit(self, "Snap")
	
	if isPlayerClose:
		var nextMove = randi_range(0,10)
		if nextMove == 0 or nextMove == 1:
			if prevMove != "Uppercut":
				stamina -= staminaCosts["Uppercut"]
				trasitioned.emit(self, "Uppercut")
		if nextMove == 2:
			if prevMove != "GroundSlam":
				stamina -= staminaCosts["GroundSlam"]
				trasitioned.emit(self, "GroundSlam")
		if nextMove == 3:
			if prevMove != "PalmStrike":
				stamina -= staminaCosts["PalmStrike"]
				trasitioned.emit(self, "PalmStrike")
		if nextMove == 4 or nextMove == 5:
			if prevMove != "Dash":
				stamina -= staminaCosts["Dash"]
				trasitioned.emit(self, "Dash")
		if nextMove > 5:
			if prevMove != "Teleport":
				stamina -= staminaCosts["Teleport"]
				trasitioned.emit(self, "Teleport")
			
	if isPlayerMedium:
		var nextMove = randi_range(0, 7)
		if nextMove == 1 or nextMove == 2:
			if prevMove != "PalmStrike":
				stamina -= staminaCosts["PalmStrike"]
				trasitioned.emit(self, "PalmStrike")
		if nextMove == 3 or nextMove == 4 or nextMove == 5:
			if prevMove != "Dash":
				stamina -= staminaCosts["Dash"]
				trasitioned.emit(self, "Dash")
		if nextMove == 6:
			if prevMove != "GroundSlam":
				stamina -= staminaCosts["GroundSlam"]
				trasitioned.emit(self, "GroundSlam")
		if nextMove > 6:
			if prevMove != "Teleport":
				stamina -= staminaCosts["Teleport"]
				trasitioned.emit(self, "Teleport")
	
	if isPlayerFar:
		var nextMove = randi_range(0,2)
		if nextMove == 0:
			if prevMove != "Fireball":
				stamina -= staminaCosts["Fireball"]
				trasitioned.emit(self, "Fireball")
		if nextMove == 1:
			if prevMove != "PalmStrike":
				stamina -= staminaCosts["PalmStrike"]
				trasitioned.emit(self, "PalmStrike")
		if nextMove > 1:
			if prevMove != "Teleport":
				stamina -= staminaCosts["Teleport"]
				trasitioned.emit(self, "Teleport")
				

func enter():
	spriteAnimator.play("Idle")
	timer = 0.4
	if stamina <= 0:
		recharge = true
	else:
		recharge = false
	if parent.phase == 2:
		crazyComboCooldown -= 1

func exit(newState : State):
	prevMove = newState.name
