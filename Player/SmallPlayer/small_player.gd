extends CharacterBody2D
class_name SmallPlayer

@export var sprite : Sprite2D

const SPEED = 50.0
const JUMP_VELOCITY = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var v : Vector2 = Vector2.ZERO #substitute for velocity so that the charectar will freze if canMove / canFall is false
var dashV : Vector2 = Vector2.ZERO

func update_physics(delta, canFall : bool, canMove : bool):
	velocity = Vector2.ZERO
	
	if canFall:
		if not is_on_floor():
			v.y += gravity * delta
		elif is_on_floor() and v.y > 0:
			v.y = 0;
		velocity.y += v.y
	
	if canMove:
		var direction = Input.get_axis("Left", "Right")
		if direction:
			v.x = move_toward(v.x, direction * SPEED, 8.0 * delta * 60);
		else:
			v.x = move_toward(v.x, 0.0, 8.0 * delta * 60);
		velocity.x += v.x
	
	if dashV.x != 0.0:
		velocity += dashV
		
	if velocity.x > 5:
		sprite.flip_h = true
	if velocity.x < -5:
		sprite.flip_h = false
	
	move_and_slide()

func facingRight():
	return sprite.flip_h

func jump():
	v.y = JUMP_VELOCITY
