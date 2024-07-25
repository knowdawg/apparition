extends State
class_name ReaperAttack

@export var parent : Reaper
@export var sprite : AnimatedSprite2D
@export var hitbox : HitboxComponent
@export var effectSound : SoundPlayer
@export var attack1Sound : SoundPlayer
@export var attack2Sound : SoundPlayer

var t = 2.3

var soundPlayed = false
func update(delta):
	t -= delta
	
	if t < 1.2 and soundPlayed == false:
		attack1Sound.playSound(1.0, 1.1)
		attack2Sound.playSound()
		soundPlayed = true
	
	if t > 1.0 and t < 1.2:
		hitbox.collisionShape.disabled = false
	else:
		hitbox.collisionShape.disabled = true
	
	if t<= delta:
		trasitioned.emit(self, "Run")

func enter():
	soundPlayed = false
	hitbox.generateAttackID()
	
	parent.velocity = Vector2.ZERO
	t = 2.3
	sprite.play("Attack")
	
	if Game.player.global_position >= parent.global_position:
		hitbox.scale.x = -1.0
		sprite.flip_h = true
	else:
		hitbox.scale.x = 1.0
		sprite.flip_h = false
	
	effectSound.playSound(0.9, 1.1)
