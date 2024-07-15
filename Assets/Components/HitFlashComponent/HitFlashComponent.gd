extends Sprite2D
class_name HitFlashComponent

@export var durration : float = 0.1

func _ready():
	modulate = Color(1.0, 1.0, 1.0, 0.0)

func flash():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Timer.start(durration)

func _on_timer_timeout():
	modulate = Color(1.0, 1.0, 1.0, 0.0)
