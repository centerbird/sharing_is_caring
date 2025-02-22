class_name UnoccupiedTile extends ReducableArea
## Defines an unoccupied tile.
##
## These tiles aren't currently occupied by [Village]s, [PathTile]s or [ResourceTile]s.
## These tiles transform into [PathTile]s when clicked upon.
## @experimental : not yet complete

## The [PathTile], that this [UnoccupiedTile] will turn into
@export var path_tile := preload("res://Scenes/tiles/path_tile.tscn")

## Transforms this scene into a [PathTile]... by instantiating a [PathTile] and destroying this [UnoccuppiedSpace].
func _on_button_pressed() -> void:
	var path = path_tile.instantiate()
	path.transform = transform
	get_window().add_child(path)
	queue_free()
