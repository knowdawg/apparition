extends CharacterBody2D
class_name BossArrow

var SPEED = 500
var dirrection = Vector2.ZERO
var boss

var state = "projectile"

func initialize(dir : Vector2, speed : float):
	SPEED = speed
	dirrection = dir
	look_at(dir)

func wiggle():
	$GlowAnimater.play("Wiggle")

func activate():
	$BashComponent.disable()
	var target = Vector2(boss.global_position.x, boss.global_position.y - 12)
	var dis = position.distance_to(target)
	$Recall/CollisionShape2D.shape.length = dis
	$Recall/PositionReset/Line2D.add_point(position)
	$Recall/PositionReset/Line2D.add_point(target)
	$GlowAnimater.play("Activate")
	look_at(target)

func bash():
	state = "bashing"
	$HitboxComponent.disable()
	
func bash_complete():
	boss.removeProjectile(self)
	queue_free()

func _process(delta):
	if state == "projectile":
		position += dirrection * SPEED * delta
		
		if $RayCast2D.is_colliding():
			position = $RayCast2D.get_collision_point()
			state = "bashReady"
			$BashComponent.activate()
			$HitboxComponent.disable()
			$GlowAnimater.play("Glow")

