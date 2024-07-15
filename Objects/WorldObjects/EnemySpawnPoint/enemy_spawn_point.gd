extends Marker2D
class_name EnemySpawnPoint

@export var enemy : PackedScene
@export var bashShield : bool = false
@export var wave : int = 0

func _ready():
	$AnimatedSprite2D.visible = false
	if bashShield:
		$Sprite2D.modulate = Color("a53030", 1.0)
		$AnimatedSprite2D.material.set_shader_parameter("color", Color("a53030", 1.0))

func spawn():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("Spawn")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Spawn":
		var e = enemy.instantiate()
		e.bashShield = bashShield
		get_parent().addEnemy(e, global_position)
		$AnimatedSprite2D.play("SpawnFinish")
		$AnimationPlayer.play("Spawn")
	else:
		$AnimatedSprite2D.visible = false


