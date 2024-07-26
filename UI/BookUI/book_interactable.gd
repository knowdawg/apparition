extends Node2D

@onready var prox : ProximityAreaComponent = $ProximityArea
@export var book : BookUI

var open = false

func _process(_delta):
	if prox.is_player_inside() and Input.is_action_just_pressed("Interact") and open == false:
		book.open()
		open = true
	elif Input.is_action_just_pressed("Interact") and open == true:
		book.close()
		open = false
	elif !prox.is_player_inside() and open == true:
		book.close()
		open = false
	
	if open == true:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			book.turnPage()
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			book.turnPageBack()
