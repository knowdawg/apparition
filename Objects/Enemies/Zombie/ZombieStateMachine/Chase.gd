extends State
class_name ZombieChase

@export var parrent : Zombie
@export var proximityArea : ProximityAreaComponent
@export var attackProximityArea : ProximityAreaComponent
@export var sprite : AnimatedSprite2D

var player : Player

func update_physics(delta):
	parrent.update_physics(delta)
	parrent.check_for_jump()
	parrent.move(1.0, delta)

func update(_delta):
	if player:
		parrent.align(player)
	
	if attackProximityArea.is_player_inside():
		trasitioned.emit(self, "Slash")
	
	if not proximityArea.is_player_inside():
		trasitioned.emit(self, "Idle")

func enter():
	sprite.play("Run")
	player = proximityArea.get_player()
	if player == null: #if player is not inside the area, it returns null
		trasitioned.emit(self, "Idle")

func hit(_attack : Attack):
	trasitioned.emit(self, "HitStun")
