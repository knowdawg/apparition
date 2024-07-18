extends Node2D

@export var SPEED = 500
var dirrection = Vector2.ZERO

func initialize(dir : Vector2):
	dirrection = dir
	look_at(dir)

func _process(delta):
	position += dirrection * SPEED * delta


func _on_envirment_checker_body_entered(_body):
	queue_free()
