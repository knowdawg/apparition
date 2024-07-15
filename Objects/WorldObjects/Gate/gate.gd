extends StaticBody2D
class_name Gate

@export var flip = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.position.y = -25
	$CollisionShape2D/Sprite2D.flip_h = flip

func close():
	$AnimationPlayer.play("Close")

func open():
	$AnimationPlayer.play("Open")
