class_name WhatCouldGoWrong extends Node2D
## Detects when the grid is supposed to be enlarged.
##
## This button signals the game world to enlage. It can only be pressed after a set period of time has passed.
## Said preiod increases with each press of the button.

## Emitted when the grid is supposed to enlarge.
signal enlarge_grid

# cumulative time to wait
var _timer : float = 0

## Time elapsed between blinking.
@export var blink_interval : float = 0.3

## Number of times it blinks when it reappears.
@export var blink_amount : int = 3

## If [code]true[/code] the amount of time to wait between reappearances is increased linearly by a set amount (in seconds).
@export var augments_linearly : bool = true

## The amount of time to add linearly each time.
@export var linear_increase : int = 180

## The amount of time to add geometrically each time (time * [member geometric_increase]).
## @experimental : doesn't seem to work right
@export var geometric_increase : float = 1.8

# Keeps track of whether the button is ready or not
var _button_ready : bool = false

## Prepares the timer.
func _ready():
	if not augments_linearly:
		_timer = 1
	_button_ready = true

# Increases the timer by the proper amount.
func _increase_timer():
	if augments_linearly:
			_timer += linear_increase
	else:
		_timer = _timer * geometric_increase

## Goes invisible for a set duration and then reappears.
func _on_button_pressed() -> void:
	if _button_ready:
		_button_ready = false
		enlarge_grid.emit()
		$Blinkie.hide()
		await get_tree().create_timer(_timer).timeout
		_increase_timer()
		for i in range(blink_amount):
			$Blinkie.show()
			await get_tree().create_timer(blink_interval).timeout
			$Blinkie.hide()
			await get_tree().create_timer(blink_interval).timeout
		$Blinkie.show()
		_button_ready = true
