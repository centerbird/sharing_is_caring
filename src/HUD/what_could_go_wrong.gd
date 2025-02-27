class_name WhatCouldGoWrong extends Node2D
## Detects when the grid is supposed to be enlarged.
##
## This button signals the game world to enlage. It can only be pressed after a set period of time has passed.
## Said preiod increases with each press of the button.

## Emitted when the grid is supposed to enlarge.
signal enlarge_grid

## Cumulative time to wait. [br] Set in Editor for initial waiting time.
@export var timer : float = 1

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

## Waits until the button is ready to be pressed for the first time.
func _ready() -> void:
	_await()

# Increases the timer by the proper amount.
func _increase_timer() -> void:
	if augments_linearly:
			timer += linear_increase
	else:
		timer = timer * geometric_increase

## Button's background becomes invisible for a set duration and then reappears.
func _on_button_pressed() -> void:
	if _button_ready:
		_button_ready = false
		enlarge_grid.emit()
		
		await get_tree().create_timer(.2).timeout
		$".."/".."/NavigationRegion2D.bake_navigation_polygon() #Hud/SharingIsCaring/NavigationRegion2D
		
		_await()

# Makes the button unavailable for a set amount of time.
func _await() -> void:
	$Blinkie.hide()
	await get_tree().create_timer(timer).timeout
	_increase_timer()
	for i in range(blink_amount):
		$Blinkie.show()
		await get_tree().create_timer(blink_interval).timeout
		$Blinkie.hide()
		await get_tree().create_timer(blink_interval).timeout
	$Blinkie.show()
	_button_ready = true
