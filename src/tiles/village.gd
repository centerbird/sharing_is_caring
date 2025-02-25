class_name Village extends Area2D
## TODO

@export var villager_scene : PackedScene

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
	var villager = villager_scene.instantiate()
	villager.setup(self, $"../ResourceTile")
	villager.position = position
	#get_window().add_child(villager)
	$"..".add_child(villager)
	print("Village at: ", global_position)
	print("Villager at: ", villager.global_position)
	

func _on_body_entered(area: Node2D) -> void:
	area.target = area._resourceNode
	print("village trigger")
	print(area.target.global_position)
