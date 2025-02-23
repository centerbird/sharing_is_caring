class_name Grid extends Node2D
## Responsible for populating the world with different kinds of tiles.
##
## @experimental : TODO

## Village tile.
## [br][br] These tiles are responsible for updating the game's state, spawning [Villager]s and assigning them .
@export var village := preload("res://Scenes/tiles/village.tscn")

## Unoccupied tiles of the scene.
## [br][br] The most common type of tile. TODO : connect signal at spawn
@export var empty := preload("res://Scenes/tiles/unoccupied_tile.tscn")

## Resource tiles serve as fuel for [Village]s.
@export var resource : Resource

## A path tile.
## [br][br] Path tiles connect game world elements together. They inform the villages of the location of resources and direct villagers that traverse them.
@export var path := preload("res://Scenes/tiles/path_tile.tscn")

## A destroyed tile.
## [br][br] These tiles serve as obstacles now.
@export var destroyed := preload("res://Scenes/tiles/destroyed.tscn")

# Number of spawned villages TODO : increase each time a village spawns
var _village_number : int = 0

## Emitted when a new [Village] is added to the game world.
signal new_village # TODO : emit newly spawned node as argument

## Populates the initial scene
func populate() -> void:
	pass # TODO

## Rescales the [Grid] and populates the newly appeared empty area.
func _on_enlarge() -> void:
	pass # TODO

