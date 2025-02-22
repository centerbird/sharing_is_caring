class_name HealthBar extends Node2D
## Manages the health bar of a single [Village]
##
## @experimental : not yet finished

## Amount of health a village has.
@export var health : int = 7

## The width until which the [HealthBar] should stretch (in pixels).
@export var width : int = 900

## Unit representing a single health point.
@export var unit := preload("res://Scenes/HUD/health/health_unit.tscn")

## Associated village is dead.
signal game_over

# current amount of health
var _current_health := 0

## Increases health by one, up to its maximum. TODO
func gain_health():
	_current_health += 1
	
## Decreses health by one. TODO
func loose_health():
	_current_health -= 1
	if _current_health == 0:
		game_over.emit()
