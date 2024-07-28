extends Area2D
class_name CheckpointGate

var state : String = "closed"
@export var flip : bool = false
@export var level : Level

@onready var id : String = level.get_name() + get_name()
# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionShape2D/Sprite2D.flip_h = flip
	
	if Game.checkpointGateActivationStatus.has(id):
		if Game.checkpointGateActivationStatus[id] == true:
			state = "open"
	else:
		Game.checkpointGateActivationStatus[id] = false

func open():
	state = "opening"
	Game.checkpointGateActivationStatus[id] = true
	$AnimationPlayer.play("Open")
	
func _process(_delta):
	if state == 'closed':
		$StaticBody2D/CollisionShape2D.position.y = 0
	elif state == 'open':
		$StaticBody2D/CollisionShape2D.position.y = -25

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Open":
		state = "open"

func _on_body_entered(body):
	if state == "closed":
		if body is Player:
			open()
