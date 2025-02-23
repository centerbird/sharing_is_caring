class_name Grid extends Node2D
## Responsible for populating the world with different kinds of tiles.
##
## Can be "zoomed out" to reveal new tiles around its initial setup.

## Village tile.
## [br][br] These tiles are responsible for updating the game's state, spawning [Villager]s and assigning them.
@export var village := preload("res://Scenes/tiles/village.tscn")

## Unoccupied tiles of the scene.
## [br][br] The most common type of tile.
@export var empty := preload("res://Scenes/tiles/unoccupied_tile.tscn")

## Resource tiles serve as fuel for [Village]s. TODO : connect signal at spawn
@export var resource := preload("res://Scenes/tiles/resource_tile.tscn")

## A path tile.
## [br][br] Path tiles connect game world elements together. They inform the villages of the location of resources and direct villagers that traverse them.
@export var path := preload("res://Scenes/tiles/path_tile.tscn")

## A destroyed tile.
## [br][br] These tiles serve as obstacles now.
@export var destroyed := preload("res://Scenes/tiles/destroyed.tscn")

## A battle tile.
##[br][br] After letting villagers kill eachother, these tiles disappear.
@export var battlefield := preload("res://Scenes/tiles/battlefield.tscn")

## Dimensions of the initial game world.
@export var dimensions := Vector2(8, 5)

## The minimum distance that a tile's center can be from the edge at the initial game world.
@export var offset : float = 64

# Number of spawned villages
var _village_number : int = 0

# Extreme grid positions on the x axis
@onready var _extreme_x := Vector2(0, dimensions.x)

# Extreme grid positions on the y axis
@onready var _extreme_y := Vector2(0, dimensions.y)

## Emitted when a new [Village] is added to the game world.
signal new_village

## Populates the initial scene
func populate() -> void:
	var deck : Array[Resource] = []
	deck.append(village)
	deck.append(village)
	deck.append(resource)
	for i in range(dimensions.x * dimensions.y - 3):
		deck.append(empty)
	deck.shuffle()
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			var instance = deck.pop_front().instantiate()
			var location = calc_location(x, y)
			if instance is Village:
				instance.free()
				spawn_village(location)
			else:
				spawn_other(location, instance)

## Calculates the [member position] of a tile, given it's order on the grid.
##[br][br]
## [param x] : horizontal order of the tile in grid
## [param y] : bertical order of the tile in grid
## [br][br][code]Returns[/code] : [member postion] of the tile
func calc_location(x : int, y : int) -> Vector2:
	return Vector2(offset + (2 * offset * x) + x, offset + (2 * offset * y) + y)

## ## Spawns a node at a given location.
## [br][br]
## [param location] : The position (relative to grid) at which to spawn the node.
func spawn_other(location : Vector2, instance : Node2D) -> void:
	if instance is UnoccupiedTile:
		instance.expired.connect(_on_empty_expire)
	elif instance is PathTile:
		instance.battle_start.connect(_on_battle_start)
	elif instance is ResourceTile:
		instance.battle_start.connect(_on_battle_start)
		instance.depleted.connect(_on_destruction)
	elif instance is Battlefield:
		instance.battle_ended.connect(_on_destruction)
	add_child(instance)
	instance.position = location

## Spawns a village at a given location.
## [br][br]
## [param location] : The position (relative to grid) at which to spawn the village.
func spawn_village(location : Vector2) -> void:
	var village_instance = village.instantiate()
	add_child(village_instance)
	village_instance.position = location
	village_instance.id(_village_number)
	_village_number += 1
	new_village.emit(village_instance)
	village_instance.modulate = SharingIsCaring.VillageColors[village_instance.get_id()]

## Rescales the [Grid] and populates the newly appeared empty area.
func _on_enlarge() -> void:
	var change = Vector2(-1,1)
	_extreme_x += change
	_extreme_y += change
	dimensions += Vector2(2, 2)
	scale.x = scale.x * 0.8
	scale.y = scale.y * (5.0/7.0)
	position.x += (1031.0 * (1.0 - scale.x) / 2.0)
	position.y += (645.0 * (1.0 - scale.y) / 2.0)
	print(position)
	print(scale)
	# TODO : test

# Spawn destroyed tile.
func _on_destruction(location : Vector2) -> void:
	spawn_other(location, destroyed.instantiate())
	

# TODO : tell people about the started battle
func _on_battle_start(location : Vector2) -> void:
	spawn_other(location, battlefield.instantiate())

# Defines the behaviour when an unoccupied tile becomes a path.
# [br][br]
# [param location] : [member position] of the expired tile.
func _on_empty_expire(location : Vector2) -> void:
	var path_instance = path.instantiate()
	add_child(path_instance)
	path_instance.position = location

# Behaviour to take at the very start of the game. Populates the initial range of [Grid].
func _on_start() -> void:
	populate()
