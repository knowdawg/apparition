extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if flip_h == false:
		offset = Vector2(0.0, 0.0)
	elif flip_h == true:
		offset = Vector2(-1.0, 0.0)
