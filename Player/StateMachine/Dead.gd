extends State
class_name PlayerDead

@export var animated_player_sprite : AnimatedSprite2D
@export var player : Player

var d = false

var k : Vector2
var g : Vector2 = Vector2.ZERO
func update_physics(delta):
	#calculate knockback
	if !k:
		k = player.currentKnockbackVector
	
	if player.is_on_floor():
		k.x = lerp(k.x, 0.0, 0.2 * delta * 60)
		if d == false:
			animated_player_sprite.play("Death", 1.0)
			d = true;
	
	k.y = lerp(k.y, 0.0, 0.2 * delta * 60)
	g.y += 200.0 * delta;
	player.velocity = k + g
	player.update_physics_no_movement(delta)

func enter():
	d = false;
	animated_player_sprite.play("Hurt")

func _on_hero_sprite_animation_finished():
	if animated_player_sprite.animation == "Death":
		Game.playerDead()
