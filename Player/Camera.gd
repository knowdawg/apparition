extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position_smoothing_enabled = false

func _process(_delta):
	position_smoothing_enabled = true
