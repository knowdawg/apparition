extends State
class_name ZombieDead

@export var parrent : Zombie

func update_physics(delta):
	parrent.update_physics(delta)
