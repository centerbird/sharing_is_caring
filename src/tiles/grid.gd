class_name Grid extends Node2D
## Responsible for populating the world with different kinds of tiles.
##
## Can be "zoomed out" to reveal new tiles around its initial setup.


## Dimensions of the initial game world.
@export var dimensions := Vector2(8, 5)

## The minimum distance that a tile's center can be from the edge at the initial game world.
@export var offset : float = 64 # TODO : get offset from sprite (half the [Sprite]'s width after scaling)

## The mximum number of [Villages] in the game that [HUD] supports.
@export var max_villages : int = 5

@export_group("Tiles")
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

@export_group("Spawn Rates")
## Spawn rate of [Village]s. 0 would mean no new [Village]s will be spawned and 100 would make every new tile a new [Village].
@export_range(0,100) var village_spawn_rate : int = 0

## Spawn rate of [Resource]s. 0 would mean no new [Resource]s will be spawned and 100 would make every new tile, that is not a [Village], a new [Resource].
## Yes, [Village]s have priority over [Reource]s.
@export_range(0,100) var resource_spawn_rate : int = 0

# Number of spawned villages
var _village_number : int = 0

# Keeps track of how small the grid has become
var _new_zero : int = 0

# Random number generator for generating random tiles.
@onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

# New dimensions of the [Grid] after rescaling.
@onready var _new_dimensions : Vector2 = dimensions

# Keeps track of the previous calculated offset
@onready var _old_offset : Vector2 = Vector2.ONE * offset

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
			spawn_tile(location, instance)

## Calculates the [member position] of a tile, given it's order on the grid.
##[br][br]
## [param x] : horizontal order of the tile in grid
## [param y] : bertical order of the tile in grid
## [br][br][code]Returns[/code] : [member postion] of the tile
func calc_location(x : int, y : int) -> Vector2:
	return Vector2(offset + (2 * offset * x) + x, offset + (2 * offset * y) + y)

## Spawns a node at a given location.
## [br][br]
## [param location] : The position (relative to grid) at which to spawn the node.
func spawn_tile(location : Vector2, instance : Node2D) -> void:
	match instance.get_script():
		UnoccupiedTile:
			instance.expired.connect(_on_empty_expire)
		PathTile:
			instance.battle_start.connect(_on_battle_start)
		ResourceTile:
			instance.battle_start.connect(_on_battle_start)
			instance.depleted.connect(_on_destruction)
		Battlefield:
			instance.battle_ended.connect(_on_destruction)
		Village:
			instance.id(_village_number)
			_village_number += 1
			new_village.emit(instance)
			instance.modulate = SharingIsCaring.VillageColors[instance.get_id()]
	instance.position = location
	add_child(instance)

## Rescales the [Grid] and populates the newly appeared empty area.
func _on_enlarge() -> void:
	var old_dimensions = _new_dimensions
	_new_dimensions += Vector2.ONE * 2
	scale.x = scale.x * (float(old_dimensions.x)/float(_new_dimensions.x)) # TODO maybe one day do actual calculations that are dynamic to different grid shapes and layouts; this applies for the three following TODOs as well

	scale.y = scale.y * (float(old_dimensions.y)/float(_new_dimensions.y)) # TODO
	#position += old_dimensions * (Vector2.ONE + _old_offset * 2) / _new_dimensions - scale
	_old_offset = _old_offset * scale
	position.x += _old_offset.x * 2#(1031.0 * (1.0 - scale.x) / 2.0) # TODO : update position properly
	position.y += _old_offset.y * 2#(645.0 * (1.0 - scale.y) / 2.0) # TODO : update position properly
	_fill_around()
	$"..".bake_navigation_polygon()

# Fills the immediate area surrounding with a one tile thick line if tiles.
func _fill_around():
	var location : Vector2
	_new_zero -= 1
	# fill top and bottom
	var new_dimensions = _new_dimensions + (Vector2.ONE * _new_zero)
	for tile_abscissa in range(_new_zero, new_dimensions.x):
		location = calc_location(tile_abscissa, _new_zero)
		spawn_tile(location, _get_random_tile_instance())
		location = calc_location(tile_abscissa, new_dimensions.y - 1)
		spawn_tile(location, _get_random_tile_instance())
	# fill sides
	for tile_ordinate in range(_new_zero + 1, new_dimensions.y - 1):
		location = calc_location(_new_zero, tile_ordinate)
		spawn_tile(location, _get_random_tile_instance())
		location = calc_location(new_dimensions.x - 1, tile_ordinate)
		spawn_tile(location, _get_random_tile_instance())

# Instantiates a random tile from the allowed options.
# [code]Returns[/code] : The instance of the newly instantiated tile.
func _get_random_tile_instance() -> Node2D:
	var x = _rng.randi_range(0, 100)
	match x:
		x when x < village_spawn_rate:
			if _village_number != max_villages:
				return village.instantiate()
		x when (x - village_spawn_rate) < resource_spawn_rate:
			return resource.instantiate()
	return empty.instantiate()

# Spawn destroyed tile.
func _on_destruction(location : Vector2) -> void:
	spawn_tile(location, destroyed.instantiate())
	

# TODO : tell people about the started battle
func _on_battle_start(location : Vector2) -> void:
	spawn_tile(location, battlefield.instantiate())

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
