extends ColorRect

@export var originNode : Marker2D
@export var active = false
@export var multiplier : float = 0.001
@export var m2 : float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active:
		var positionOnScreen = originNode.get_global_transform_with_canvas().origin
		#positionOnScreen.x -= 928
		#positionOnScreen.y -= 320
		
		material.set_shader_parameter("cameraPos", Vector3(positionOnScreen.x * -multiplier * m2 + 0.5, positionOnScreen.y * -multiplier * m2 + 0.5, -2.9))
