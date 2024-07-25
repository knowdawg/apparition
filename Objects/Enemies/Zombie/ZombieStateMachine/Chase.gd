extends State
class_name ZombieChase

@export var parrent : Zombie
@export var proximityArea : ProximityAreaComponent
@export var attackProximityArea : ProximityAreaComponent
@export var sprite : AnimatedSprite2D
@export var walkSound : AudioStreamPlayer2D

var player : Player

var soundTimer = 0.0

func update_physics(delta):
	parrent.update_physics(delta)
	parrent.check_for_jump()
	parrent.move(1.0, delta)

func update(delta):
	soundTimer -= delta
	if soundTimer <= 0.0:
		walkSound.playSound(0.25, 0.5)
		soundTimer = 0.3
	if player:
		parrent.align(player)
	
	if attackProximityArea.is_player_inside():
		trasitioned.emit(self, "Slash")
	
	if not proximityArea.is_player_inside():
		trasitioned.emit(self, "Idle")

func enter():
	soundTimer = 0.1
	sprite.play("Run")
	player = proximityArea.get_player()
	if player == null: #if player is not inside the area, it returns null
		trasitioned.emit(self, "Idle")

func hit(_attack : Attack):
	trasitioned.emit(self, "HitStun")
