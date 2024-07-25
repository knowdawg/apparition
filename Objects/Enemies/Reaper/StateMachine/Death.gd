extends State
class_name ReaperDeath

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var sound : SoundPlayer
@export var effectsSound : SoundPlayer

func update_physics(delta):
	parent.velocity.y += 500 * delta

var t = 0.5
func update(delta):
	t-= delta
	if t <= 0.0:
		sound.playSound(1.0, 1.1)
		t = 9999999999

func enter():
	t= 0.5
	parent.velocity = Vector2.ZERO
	sprite.play("Death")
	effectsSound.playSound(0.8, 0.8)
