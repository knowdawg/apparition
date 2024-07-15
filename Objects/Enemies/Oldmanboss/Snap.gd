extends State
class_name BossSnap

@export var parent : OldManBoss
@export var spriteAnimator : AnimationPlayer

func update(_delta):
	pass

func enter():
	spriteAnimator.play("Snap")

func arrowsWiggle():
	for p in parent.projectiles:
		if is_instance_valid(p):
			p.wiggle()

func fire():
	for p in parent.projectiles:
		if is_instance_valid(p):
			p.activate()
	parent.projectiles.clear()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Snap":
		trasitioned.emit(self, "Idle")
