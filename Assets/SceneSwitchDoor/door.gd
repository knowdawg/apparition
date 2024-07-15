extends Area2D
class_name Door

@export var sceneToSwitchTo : String
@export var doorToGoTo : String
@export var facingLeftNextScene : bool

func _on_body_entered(body):
	if body is Player:
		if sceneToSwitchTo and doorToGoTo:
			var data = SwitchSceneData.new()
			data.scene = sceneToSwitchTo
			data.door = doorToGoTo
			data.facingLeft = facingLeftNextScene
			Game.switch_scene(data)
			
func get_spawn_pos():
	if get_child_count() == 2:
		return get_node("Marker2D").global_position
	return Vector2.ZERO
