class_name HealthBar extends Node2D
## Manages the health bar of a single [Village]
##
## @experimental : not yet finished
## @deprecated

## Amount of health a village has.
@export var health : int = 7

## The width until which the units of health on the [HealthBar] should stretch (in pixels/scale) after village symbol.
@export var width : int = 900

## The distance by which health units are separated from one another (in pixels/scale).
@export var unit_separation_distance : int = 5

## Unit representing a single health point.
@export var unit := preload("res://Scenes/HUD/health/health_unit.tscn")

## Associated village is dead.
signal game_over

# current amount of health
var _current_health := 0

func _ready():
	_current_health = health

# Spawns the health bar TODO
func _initiate_health_bar():
	pass

## Increases health by one, up to its maximum. TODO
func gain_health():
	_current_health += 1
	
## Decreses health by one. TODO
func loose_health():
	_current_health -= 1
	if _current_health == 0:
		game_over.emit()
