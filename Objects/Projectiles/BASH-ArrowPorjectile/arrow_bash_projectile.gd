extends Node2D

@export var SPEED = 100
var dirrection = Vector2.ZERO

func initialize(dir : Vector2):
	dirrection = dir
	rotation = dir.angle()
	$SpawnSound.play()

func _process(delta):
	position += dirrection * SPEED * delta

func _on_spawn_sound_finished():
	queue_free()
