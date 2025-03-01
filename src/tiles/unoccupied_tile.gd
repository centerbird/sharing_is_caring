class_name UnoccupiedTile extends Node2D
## Defines an unoccupied tile.
##
## These tiles aren't currently occupied by [Village]s, [PathTile]s or [ResourceTile]s.
## These tiles transform into [PathTile]s when clicked upon.

# The [PathTile], that this [UnoccupiedTile] will turn into
#@export var path_tile := preload("res://Scenes/tiles/path_tile.tscn")

## Signals that this tile has transformed into a [PathTile]. Contains the current [member position] of this tile.
signal expired

## Transforms this scene into a [PathTile]... by instantiating a [PathTile] and destroying this [UnoccuppiedTile].
func _on_button_pressed() -> void:
	$Area2D/CollisionShape2D/NavigationObstacle2D.affect_navigation_mesh = false
	$Area2D/CollisionShape2D/NavigationObstacle2D.avoidance_enabled = false
	expired.emit(position)
	queue_free()
	
