extends Node2D

@export var tilemap : TileMap
@export var flip : bool = false
@export var level : Level

@onready var id : String = level.get_name() + get_name()
func _ready():
	$WallWithCracks.flip_h = flip
	
	if Game.checkpointGateActivationStatus.has(id):
		if Game.checkpointGateActivationStatus[id] == true:
			queue_free()
	else:
		Game.checkpointGateActivationStatus[id] = false

func hit(_attack : Attack):
	$AnimationPlayer.play("Hit")

func death(_attack : Attack):
	Game.checkpointGateActivationStatus[id] = true
	$HurtboxComponent.call_deferred("disable")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Death")
	if tilemap:
		var t = create_tween()
		t.tween_property(tilemap, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
