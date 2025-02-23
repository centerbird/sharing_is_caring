class_name Village extends Area2D
## TODO

## Signals that this[Village] has received a delivery of resources.
signal resource_delivery

# the ID of this village
var _id : int

## Sets the id for the village.
## [br][br]
## [param id_no] : The new id of the village.
func id(id_no : int):
	_id = id_no

## The id of this village determines in which order it was spawned to the world.
## [br][br]
## [code]Returns[/code] : ID of the village.
func get_id():
	return _id

func _after_ready():
	var villager = preload("res://Scenes/villager.tscn").instantiate()
	villager.setup(self)
	villager.global_position = global_position
	get_window().add_child(villager)
	print(position)
	print(villager.position)
