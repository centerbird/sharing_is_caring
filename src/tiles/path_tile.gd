class_name PathTile extends Area2D
## A path tile in the game world.
##
## [PathTile]s are the hiveminds of the game.
## They tiles connect game world elements together. They inform the villages of the location of resources and direct villagers that traverse them.
## If they detect that more than one village is connected to them through path tiles alone they are replace themselves with a battlefield
## @experimental : not yet complete TODO : Check surroundings if resource or village, add to list with d=0; if path, get list; compare common elements in lists; signal to modify if need be

# check to see if this [PathTile] has just spawned and thereby has the capacity to turn into a [Battlefield].
var _is_field := true

## Signals that a battle has started on this tile.
signal battle_start
