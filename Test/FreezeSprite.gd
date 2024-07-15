extends Sprite2D
class_name ColdEffect

func _process(_delta):
	var c = Vector2.ZERO
	
	c = Game.player.get_global_transform_with_canvas().get_origin()
	c /= get_viewport_rect().size
	
	material.set_shader_parameter("center", c)
	
func set_cold(amount):
	material.set_shader_parameter("progress", amount)
	material.set_shader_parameter("intensity", clamp(amount * 2.0, 0.0, 1.0))
