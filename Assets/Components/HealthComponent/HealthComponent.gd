extends Node2D
class_name HealthComponent

@export var parrent : Node2D
@export var bar : Control

@export var MAX_HEALTH := 10.0
var health : float
@export var locked = false

func _ready():
	health = MAX_HEALTH

func _process(_delta):
	if bar:
		bar.update(health, MAX_HEALTH)

func get_health():
	return health

func get_max_health():
	return MAX_HEALTH

func set_max_health(value : float):
	MAX_HEALTH = value

func set_health(val : float):
	if val > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health = val

func damage(attack : Attack):
	if locked == true:
		attack.attack_damage = 0.0
		attack.knockback_force *= 0.5
	
	health -= attack.attack_damage
	if bar:
		bar.hit(attack.attack_damage, health + attack.attack_damage)
	if health <= 0:
		if parrent.has_method("death"):
			parrent.death(attack)
		return
	if parrent.has_method("hit"):
		parrent.hit(attack)
	
func setHealthLock(lock : bool):
	locked = lock

func isHealthLocked():
	return locked
