extends State
class_name SmallPlayerRun

@export var animator : AnimationPlayer
@export var player : SmallPlayer

func update(delta):
	player.update_physics(delta, true, true)
	
	if Input.is_action_just_pressed("Jump"):
		trasitioned.emit(self, "Jump")
		return
	if abs(player.velocity.x) < 5.0:
		trasitioned.emit(self, "Idle")
		return
	if player.velocity.y > 0.0:
		trasitioned.emit(self, "Fall")
		return
	if Input.is_action_pressed("Bash"):
		trasitioned.emit(self, "Roll")
		return

func enter():
	animator.play("Run")
