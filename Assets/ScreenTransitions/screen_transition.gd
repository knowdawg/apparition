extends CanvasLayer

signal fadeInComplete

func fadeIn():
	$ScreenAnimator.play("FadeIn")

func fadeOut():
	$ScreenAnimator.play("FadeOut")

func _on_screen_animator_animation_finished(anim_name):
	if anim_name == "FadeIn":
		fadeInComplete.emit()
	elif anim_name == "FadeOut":
		queue_free()
