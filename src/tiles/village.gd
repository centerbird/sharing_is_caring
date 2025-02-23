class_name Village extends Area2D
## [Village]s manage [Villager]s to recuperate resources and to wage war against other [Village]s.
##
## Mainly tasked with spawning [Villager]s and directing them towards different targets.

## Signals that this[Village] has received a delivery of resources.
signal resource_delivery

# the ID of this village
var _id : int

## Sets the id for the village.
## [br][br]
## [param id_no] : The new id of the village.
func id(id_no : int) -> void:
	_id = id_no

## The id of this village determines in which order it was spawned to the world.
## [br][br]
## [code]Returns[/code] : ID of the village.
func get_id() -> int:
	return _id
