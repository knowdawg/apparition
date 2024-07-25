extends State
class_name ZombieSlash

@export var parrent : Zombie
@export var sprite : AnimatedSprite2D
@export var hitbox : HitboxComponent
@export var attackSound : SoundPlayer

var timer : float = 0.0

func update(delta):
	timer += delta
	if timer >= 0.6 and timer <= 0.7:
		attackSound.playSound(0.8, 1.0)
	
	if timer >= 0.8 and timer <= 1.0:
		hitbox.collisionShape.disabled = false
		parrent.move(2.0, delta)
	else:
		hitbox.collisionShape.disabled = true

func update_physics(delta):
	parrent.update_physics(delta)

func enter():
	hitbox.generateAttackID()
	timer = 0.0
	sprite.play("Slash")

func exit(_newState):
	hitbox.call_deferred("disable")

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "Slash":
		trasitioned.emit(self, "Idle")
