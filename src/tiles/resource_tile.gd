class_name ResourceTile extends Area2D
## A source of resources for villages.
##
## Contans a set amount of resources which can be brought to villages by villagers.

## The amount of resources that this resource node spawns with.
@export var content : int = 16

## Signals that a battle has started on this tile.
signal battle_start

## Signals that there are no more resources on this node.
signal depleted

# Checks if this node is connected to any villages by paths.
var _connected_to_village := false

## Determines when the node becomes a [Battlefield].
func village_connection():
	if _connected_to_village:
		battle_start.emit(position)
		queue_free()
	else:
		_connected_to_village = true

## Consumes a resource from this node.
## [br][br]
## [code]Returns[/code] : [code]true[/code], if [ResourceTile] has indeed anything left to consume.
func consume() -> bool:
	if content > 0:
		content -= 1
		if content == 0:
			depleted.emit(position)
			queue_free()
		return true
	else:
		return false


func _on_body_entered(area: Node2D) -> void:
	area.target = area._village
