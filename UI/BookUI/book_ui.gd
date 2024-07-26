extends CanvasLayer
class_name BookUI

@export var pageNames : Array = ["Dialog 1"]

@onready var leftPage = $LeftPage
@onready var rightPage = $RightPage

var curPageEven : float = 0.0
var curPageOdd : float = 1.0

func _ready():
	if pageNames.size() - 1 >= curPageEven:
		leftPage.text = Dialog.dialog[pageNames[curPageEven]]
	if pageNames.size() - 1 >= curPageOdd:
		rightPage.text = Dialog.dialog[pageNames[curPageOdd]]

func open():
	$BookAnimator.play("Land")

func close():
	$BookAnimator.play("PutAway")

func turnPage():
	if curPageEven + 2 > pageNames.size() -1:
		return
	if !$BookAnimator.is_playing():
		$BookAnimator.play("TurnPage")

func turnPageBack():
	if curPageEven - 2 < 0:
		return
	if !$BookAnimator.is_playing():
		$BookAnimator.play("TurnPageBack")

func nextRight(isBackwards : bool = false):
	var pageToGet = curPageOdd
	if isBackwards:
		pageToGet -= 2
		if pageToGet < 1:
			return
	else:
		pageToGet += 2
	if pageNames.size() - 1 >= pageToGet:
		rightPage.text = Dialog.dialog[pageNames[pageToGet]]
		if isBackwards:
			curPageOdd -= 2
		else:
			curPageOdd += 2

func nextLeft(isBackwards : bool = false):
	var pageToGet = curPageEven
	if isBackwards:
		pageToGet -= 2
		if pageToGet < 0:
			return
	else:
		pageToGet += 2
	if pageNames.size() - 1 >= pageToGet:
		leftPage.text = Dialog.dialog[pageNames[pageToGet]]
		if isBackwards:
			curPageEven -= 2
		else:
			curPageEven += 2
