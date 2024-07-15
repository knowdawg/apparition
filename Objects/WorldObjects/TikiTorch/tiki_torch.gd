extends Node2D

@export var lightLayer : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D/PointLight2D.range_layer_min = lightLayer
	$AnimatedSprite2D/PointLight2D.range_layer_max = lightLayer
	$AnimatedSprite2D.play("Burn")

