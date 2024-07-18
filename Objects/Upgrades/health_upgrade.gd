extends Node2D

@export var room : Level
var colected = false

@onready var id : String = room.get_name() + get_name()
func _ready():
	$CanvasLayer.visible = false
	if Game.healthUpgradeStatus.has(id):
		if Game.healthUpgradeStatus[id] == true:
			colected = true
			queue_free()
		$AnimationPlayer.play("Idle")
	else:
		Game.healthUpgradeStatus[id] = false
		$AnimationPlayer.play("Idle")

func _on_area_2d_body_entered(body):
	if body is Player and colected == false:
		Game.healthUpgradeStatus[id] = true
		colected = true
		$AnimationPlayer.play("RESET")
		$Sprite.visible = false
		$CanvasLayer.visible = true
		impale()

func _process(_delta):
	$CanvasLayer/ImpaleParticles.position = $CanvasLayer/ScreenVisual.position

func impale():
	var s = $CanvasLayer/ScreenVisual
	s.position = get_global_transform_with_canvas().origin
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	
	var scaling = get_viewport_rect().size
	var destination = Vector2(0.03 * scaling.x + 1190, 0.05 * scaling.y + 50.0)
	tween.connect("step_finished", impaleReady)
	tween.tween_property(s, "position", destination, 0.75).set_trans(Tween.TRANS_CUBIC)
	
	
	destination.x = (Game.maxPlayerHealth) * 50.0 + 145 + 0.03 * scaling.x
	tween.tween_property(s, "position", destination, 1).set_trans(Tween.TRANS_EXPO)
	
	#tween.tween_property(s, "self_moduate", false, 0.0)

var hasImpaled = false
func impaleReady(_index):
	if hasImpaled == false:
		$CanvasLayer/ImpaleParticles.emitting = true
		$AnimationPlayer.play("Impale")
		hasImpaled = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Impale":
		Game.maxPlayerHealth += 1
