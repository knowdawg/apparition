extends ColorRect

@export var originNode : Marker2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#var positionOnScreen = originNode.get_global_transform_with_canvas().origin
	#positionOnScreen.x -= 928
	#positionOnScreen.y -= 320
	
	#material.set_shader_parameter("cameraPos", Vector3(positionOnScreen.x * -0.0002 + 0.5, positionOnScreen.y * -0.0002 + 0.5, -2.9))
