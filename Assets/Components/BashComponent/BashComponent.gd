extends Area2D
class_name BashComponent

@export var parrent : CharacterBody2D
@export var bashType : String
@export var collisionShape : CollisionShape2D
@export var activated = false
@export var oneShot = true

signal bashComplete

var active = false

func _process(delta):
	if active == true:
		if Game.controler:
			$Arrow.rotation = getControllerBashVector().angle()
		else:
			$Arrow.look_at(get_global_mouse_position())
		Game.currentCamera.add_shake(delta * 10.0)
		Game.currentCamera.zoom.x += delta * 3.0
		Game.currentCamera.zoom.y += delta * 3.0

func bash():
	$Timer.start()
	if parrent.has_method("bash"):
		parrent.bash()
	
	$Arrow.visible = true
	active = true
	
	$BashAnimator.play("Bash")
	
	Game.slow_down(1.0, 0.1)

var p
func _on_timer_timeout():
	if bashType.to_lower() == "shotgun":
		p = load("res://Objects/Projectiles/BASH-ShotgunProjectile/shotgun_bash_effect.tscn")
		instance_shotgun()
	elif bashType.to_lower() == "arrow":
		p = load("res://Objects/Projectiles/BASH-ArrowPorjectile/arrow_bash_projectile.tscn")
		instance_arrow()
	elif bashType.to_lower() == "scythe":
		p = load("res://Objects/Projectiles/BASH-Scythe/bash_scythe_projectile.tscn")
		instance_scythe()
	elif bashType.to_lower() == "nothing":
		pass
	else:
		p = load("res://Objects/Projectiles/BASH-ShotgunProjectile/shotgun_bash_effect.tscn")
		instance_shotgun()
		push_warning("ERROR: Projectile Not Found for Bash Component")
	
	bashComplete.emit()
	
	$Arrow.visible = false
	active = false
	Game.currentCamera.set_shake(5.0)
	Game.currentCamera.zoom = Vector2(10.0, 10.0)
	
	if parrent.has_method("bash_complete"):
		parrent.bash_complete()
	
	if oneShot:
		collisionShape.disabled = true

func getControllerBashVector() -> Vector2:
	var stickVector = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), 
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)).normalized()
	return stickVector

func instance_scythe():
	var projectile = p.instantiate()
	Game.currentLevel.add_projectile(projectile)
	projectile.position = global_position
	
	if Game.controler:
		projectile.initialize(getControllerBashVector())
	else:
		projectile.initialize(-($Arrow.global_position - get_global_mouse_position()).normalized())

func instance_arrow():
	var projectile = p.instantiate()
	Game.currentLevel.add_projectile(projectile)
	projectile.position = global_position
	if Game.controler:
		projectile.initialize(getControllerBashVector())
	else:
		projectile.initialize(-($Arrow.global_position - get_global_mouse_position()).normalized())

func instance_shotgun():
	var projectile = p.instantiate()
	Game.currentLevel.add_projectile(projectile)
	projectile.position = global_position
	projectile.rotation_degrees = $Arrow.rotation_degrees

func _ready():
	$Arrow.visible = false
	
	if collisionShape:
		collisionShape.disabled = !activated

func activate():
	if collisionShape:
		collisionShape.disabled = false

func disable():
	if collisionShape:
		collisionShape.disabled = true
