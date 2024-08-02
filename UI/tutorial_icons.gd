extends Area2D

@export_multiline var text : String
@export var waitTime : float
@export var enabled = true

var playingInside = false

func _ready():
	$TutorialIcons/Control/Label.text = "[center]" + text + "[/center]"
	t = waitTime
	

var t = 0.0
func _physics_process(delta):
	if enabled:
		if playingInside:
			t -= delta
			if t <= 0 and $TutorialIcons/Control/Label.modulate.a == 0.0:
				$AnimationPlayer.play("Show")
		if !playingInside and $TutorialIcons/Control/Label.modulate.a > 0.0:
			t = waitTime
			$AnimationPlayer.play("Hide")

func _on_body_entered(body):
	if body is Player:
		playingInside = true

func _on_body_exited(body):
	if body is Player:
		playingInside = false

func enable():
	enabled = true

func disable():
	enabled = false
	if $TutorialIcons/Control/Label.modulate.a > 0.0:
		$AnimationPlayer.play("Hide")
	
