extends Node2D
class_name DialogBubble

@export_multiline var text : String = ""
@export var time : float = 2.0
@export var isCutScene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DialogBuble/RichTextLabel.text = "[center]" + text

var initialized = false

func initialize():
	if initialized == false:
		if !isCutScene:
			$DeleteTimer.start(time)
		$DialogBuble/RichTextLabel.text = "[center]" + text
		$LifeAnimator.play("Spawn")
		initialized = true

var finished = false
func finish():
	if !finished:
		$LifeAnimator.play("Delete")
		finished = true

func _on_delete_timer_timeout():
	$LifeAnimator.play("Delete")

func _on_life_animator_animation_finished(anim_name):
	if anim_name == "Delete":
		pass
