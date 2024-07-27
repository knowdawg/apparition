extends Node2D

func _ready():
	$Timer.start(randf_range(3,6))

func _on_timer_timeout():
	$DialogBuble.initialized = false
	$DialogBuble.finished = false
	$DialogBuble.initialize()
	$Timer.start(randf_range(3,6))
