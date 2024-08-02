extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _process(_delta):
	if is_instance_valid(Game.currentLevel):
		if Input.is_action_just_pressed("Menu") and visible == false:
			visible = true
			$Panel/VBoxContainer/Resume.grab_focus()
			Game.pause()
		elif Input.is_action_just_pressed("Menu") and visible == true:
			visible = false
			Game.resume()

func _on_resume_pressed():
	visible = false
	Game.resume()

func _on_quit_pressed():
	Game.save()
	visible = false
	Game.resume()
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")
